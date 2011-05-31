# encoding: UTF-8
require RUBY_VERSION < '1.9' ? 'fastercsv' : 'csv'

module RailsAdmin
  
  CSVClass = RUBY_VERSION < '1.9' ? ::FasterCSV : ::CSV

  class CSVConverter
    
    def initialize(objects = [], schema = {})
      return self if (@objects = objects).blank?

      @methods = [(schema[:only] || []) + (schema[:methods] || [])].flatten.compact
      @model = objects.first.class
      @abstract_model = RailsAdmin::AbstractModel.new(@model)
      @model_config = RailsAdmin.config(@abstract_model)
      @empty = ::I18n.t('admin.export.empty_value_for_associated_objects')
      @associations = {}

      (schema.delete(:include) || {}).each do |key, values|
        association = @abstract_model.associations.find{ |association| association[:name] == key }
        model = association[:type] == :belongs_to ? association[:parent_model] : association[:child_model]
        abstract_model = RailsAdmin::AbstractModel.new(model)
        model_config = RailsAdmin.config(abstract_model)
        
        @associations[key] = {
          :association => association,
          :model => model,
          :abstract_model => abstract_model,
          :model_config => model_config,
          :methods => [(values[:only] || []) + (values[:methods] || [])].flatten.compact
        }
      end
    end

    def to_csv(options)
      options ||= {}
      return '' if @objects.blank?
      
      # encoding shenanigans first
      # 
      encoding_from = if [nil, '', 'utf8', 'utf-8', 'UTF8', 'UTF-8'].include?(encoding = Rails.configuration.database_configuration[Rails.env]['encoding'])
        'UTF-8'
      else
        encoding
      end
      
      unless options[:encoding_to].blank?
        encoding_to = options[:encoding_to]
        unless encoding_to == encoding_from
          require 'iconv'
          @iconv = Iconv.new("#{encoding_to}//TRANSLIT//IGNORE", encoding_from)
        end
      else
        encoding_to = encoding_from
      end

      
      csv_string = CSVClass.generate(options[:generator] ? options[:generator].symbolize_keys.delete_if {|key, value| value.blank? } : {}) do |csv|
        unless options[:skip_header]
          csv << @methods.map do |method|
            output(::I18n.t('admin.export.csv.header_for_root_methods', :name => @model.human_attribute_name(method), :model => @abstract_model.pretty_name))
          end +
          @associations.map do |association_name, option_hash|
            option_hash[:methods].map do |method|
              output(::I18n.t('admin.export.csv.header_for_association_methods', :name => option_hash[:model].human_attribute_name(method), :association => @model.human_attribute_name(association_name)))
            end
          end.flatten
        end

        @objects.each do |object|
          csv << @methods.map do |method|
            output(object.send(method))
          end +
          @associations.map do |association_name, option_hash|
            associated_objects = [object.send(association_name)].flatten.compact
            option_hash[:methods].map do |method|
              output(associated_objects.map{ |obj| obj.send(method).presence || @empty }.join(','))
            end
          end.flatten
        end
      end

      # Add a BOM for utf8 encodings, helps with utf8 auto-detect for some versions of Excel. 
      # Don't add if utf8 but user don't want to touch input encoding:
      # If user chooses utf8, he will open it in utf8 and BOM will disappear at reading. 
      # But that way "English" users who don't bother and chooses to let utf8 by default won't get BOM added
      # and will not see it if Excel opens the file with a different encoding.
      csv_string = "\xEF\xBB\xBF#{csv_string}" if options[:encoding_to] == 'UTF-8' 
      [!options[:skip_header], encoding_to, csv_string]
    end
    
    
    private 
    
    def output(str)
      (@iconv ? @iconv.iconv(str.to_s) : str.to_s) rescue str
    end
  end
end

