# encoding: UTF-8
require RUBY_VERSION < '1.9' ? 'fastercsv' : 'csv'

module RailsAdmin

  CSVClass = RUBY_VERSION < '1.9' ? ::FasterCSV : ::CSV
  NON_ASCII_ENCODINGS = /(UTF\-16)|(UTF\-32)|(ISO\-2022\-JP)|(Big5\-HKSCS)|(UTF\-7)/
  UTF8_ENCODINGS = [nil, '', 'utf8', 'utf-8', 'unicode', 'UTF8', 'UTF-8', 'UNICODE']

  class CSVConverter

    def initialize(objects = [], schema = {})
      return self if (@objects = objects).blank?

      @model = objects.dup.first.class
      @abstract_model = RailsAdmin::AbstractModel.new(@model)
      @model_config = @abstract_model.config
      @methods = [(schema[:only] || []) + (schema[:methods] || [])].flatten.compact
      @fields = @methods.map {|m| @model_config.export.fields.find {|f| f.name == m} }
      @empty = ::I18n.t('admin.export.empty_value_for_associated_objects')
      @associations = {}

      (schema.delete(:include) || {}).each do |key, values|
        association = @model_config.export.fields.find{|f| f.name == key && f.association?}
        model_config = association.associated_model_config
        abstract_model = model_config.abstract_model
        model = abstract_model.model
        methods = [(values[:only] || []) + (values[:methods] || [])].flatten.compact
        fields = methods.map {|m| model_config.export.fields.find {|f| f.name == m} }

        @associations[key] = {
          :association => association,
          :model => model,
          :abstract_model => abstract_model,
          :model_config => model_config,
          :fields => fields
        }
      end
    end

    def to_csv(options)
      options ||= {}
      return '' if @objects.blank?

      # encoding shenanigans first
      @encoding_from = UTF8_ENCODINGS.include?(@abstract_model.encoding) ? 'UTF-8' : @abstract_model.encoding

      unless options[:encoding_to].blank?
        @encoding_to = options[:encoding_to]
        unless @encoding_to == @encoding_from
          require 'iconv'
          @iconv = (Iconv.new("#{@encoding_to}//TRANSLIT//IGNORE", @encoding_from) rescue (Rails.logger.error("Iconv cannot convert to #{@encoding_to}: #{$!}\nNo conversion will take place"); nil))
        end
      else
        @encoding_to = @encoding_from
      end

      csv_string = CSVClass.generate(options[:generator] ? options[:generator].symbolize_keys.delete_if {|key, value| value.blank? } : {}) do |csv|
        unless options[:skip_header]
          csv << @fields.map do |field|
            output(::I18n.t('admin.export.csv.header_for_root_methods', :name => field.label, :model => @abstract_model.pretty_name))
          end +
          @associations.map do |association_name, option_hash|
            option_hash[:fields].map do |field|
              output(::I18n.t('admin.export.csv.header_for_association_methods', :name => field.label, :association => option_hash[:association].label))
            end
          end.flatten
        end
        @objects.each do |o|


          csv << @fields.map do |field|
            output(field.with(:object => o).export_value)
          end +
          @associations.map do |association_name, option_hash|

            associated_objects = [o.send(association_name)].flatten.compact
            option_hash[:fields].map do |field|
              output(associated_objects.map{ |ao| field.with(:object => ao).export_value.presence || @empty }.join(','))
            end
          end.flatten
        end
      end

      # Add a BOM for utf8 encodings, helps with utf8 auto-detect for some versions of Excel.
      # Don't add if utf8 but user don't want to touch input encoding:
      # If user chooses utf8, he will open it in utf8 and BOM will disappear at reading.
      # But that way "English" users who don't bother and chooses to let utf8 by default won't get BOM added
      # and will not see it if Excel opens the file with a different encoding.
      csv_string = "\xEF\xBB\xBF#{csv_string.respond_to?(:force_encoding) ? csv_string.force_encoding('UTF-8') : csv_string}" if options[:encoding_to] == 'UTF-8'
      csv_string = ((@iconv ? @iconv.iconv(csv_string) : csv_string) rescue str) if @encoding_to =~ NON_ASCII_ENCODINGS # global conversion for non ASCII encodings
      [!options[:skip_header], @encoding_to, csv_string]
    end

    private

    def output(str)
      unless @encoding_to =~ NON_ASCII_ENCODINGS  # can't use the csv generator with encodings that are no supersets of ASCII-7
        (@iconv ? @iconv.iconv(str.to_s) : str.to_s) rescue str.to_s   # convert piece by piece
      else
        str.to_s
      end
    end
  end
end
