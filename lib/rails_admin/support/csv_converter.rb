# encoding: UTF-8
require RUBY_VERSION < '1.9' ? 'fastercsv' : 'csv'

module RailsAdmin
  CSV_CLASS = RUBY_VERSION < '1.9' ? ::FasterCSV : ::CSV
  NON_ASCII_ENCODINGS = /(UTF\-16)|(UTF\-32)|(EUC\-JP)|(ISO\-2022\-JP)|(Shift_JIS)|(Big5\-HKSCS)|(UTF\-7)/
  UTF8_ENCODINGS = [nil, '', 'utf8', 'utf-8', 'unicode', 'UTF8', 'UTF-8', 'UNICODE']

  class CSVConverter
    def initialize(objects = [], schema = {})
      return self if (@objects = objects).blank?

      @model = objects.dup.first.class
      @abstract_model = RailsAdmin::AbstractModel.new(@model)
      @model_config = @abstract_model.config
      @methods = [(schema[:only] || []) + (schema[:methods] || [])].flatten.compact
      @fields = @methods.collect { |m| export_fields_for(m).first }
      @empty = ::I18n.t('admin.export.empty_value_for_associated_objects')
      schema_include = schema.delete(:include) || {}

      @associations = schema_include.each_with_object({}) do |(key, values), hash|
        association = association_for(key)
        model_config = association.associated_model_config
        abstract_model = model_config.abstract_model
        methods = [(values[:only] || []) + (values[:methods] || [])].flatten.compact

        hash[key] = {
          association: association,
          model: abstract_model.model,
          abstract_model: abstract_model,
          model_config: model_config,
          fields: methods.collect { |m| export_fields_for(m, model_config).first },
        }
        hash
      end
    end

    def to_csv(options = {})
      # encoding shenanigans first
      @encoding_from = UTF8_ENCODINGS.include?(@abstract_model.encoding) ? 'UTF-8' : @abstract_model.encoding

      @encoding_to = options[:encoding_to].presence || @encoding_from

      csv_string = generate_csv_string(options)

      # Add a BOM for utf8 encodings, helps with utf8 auto-detect for some versions of Excel.
      # Don't add if utf8 but user don't want to touch input encoding:
      # If user chooses utf8, they will open it in utf8 and BOM will disappear at reading.
      # But that way "English" users who don't bother and chooses to let utf8 by default won't get BOM added
      # and will not see it if Excel opens the file with a different encoding.
      if options[:encoding_to] == 'UTF-8'
        csv_string = csv_string.force_encoding('UTF-8') if csv_string.respond_to?(:force_encoding)
        csv_string = "\xEF\xBB\xBF#{csv_string}"
      end
      # global conversion for non ASCII encodings
      if @encoding_to =~ NON_ASCII_ENCODINGS && @encoding_to != @encoding_from
        require 'iconv'
        begin
          if @iconv = Iconv.new("#{@encoding_to}//TRANSLIT//IGNORE", @encoding_from)
            csv_string = @iconv.iconv(csv_string) rescue csv_string
          end
        rescue
          Rails.logger.error("Iconv cannot convert to #{@encoding_to}: #{$ERROR_INFO}\nNo conversion will take place")
        end
      end
      [!options[:skip_header], @encoding_to, csv_string]
    end

  private

    def association_for(key)
      export_fields_for(key).detect(&:association?)
    end

    def export_fields_for(method, model_config = @model_config)
      model_config.export.fields.select { |f| f.name == method }
    end

    def generate_csv_string(options)
      generator_options = (options[:generator] || {}).symbolize_keys.delete_if { |_, value| value.blank? }
      CSV_CLASS.generate(generator_options) do |csv|
        csv << generate_csv_header unless options[:skip_header]

        method = @objects.respond_to?(:find_each) ? :find_each : :each
        @objects.send(method) do |object|
          csv << generate_csv_row(object)
        end
      end
    end

    def generate_csv_header
      @fields.collect do |field|
        output(::I18n.t('admin.export.csv.header_for_root_methods', name: field.label, model: @abstract_model.pretty_name))
      end +
      @associations.flat_map do |_association_name, option_hash|
        option_hash[:fields].collect do |field|
          output(::I18n.t('admin.export.csv.header_for_association_methods', name: field.label, association: option_hash[:association].label))
        end
      end
    end

    def generate_csv_row(object)
      @fields.collect do |field|
        output(field.with(object: object).export_value)
      end +
      @associations.flat_map do |association_name, option_hash|
        associated_objects = [object.send(association_name)].flatten.compact
        option_hash[:fields].collect do |field|
          output(associated_objects.collect { |ao| field.with(object: ao).export_value.presence || @empty }.join(','))
        end
      end
    end

    def output(str)
      # Can't use the CSV generator with encodings that are not supersets of ASCII-7
      return str.to_s if @encoding_to =~ NON_ASCII_ENCODINGS || !@iconv

      # Convert piece by piece
      @iconv.iconv(str.to_s) rescue str.to_s
    end
  end
end
