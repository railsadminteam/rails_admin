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
      @empty = ::I18n.t('admin.export.empty_value')
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

    def to_csv(options = {})
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

      
      csv_string = CSVClass.generate() do |csv|
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
              output(associated_objects.map{ |obj| obj.send(method).presence || @empty }.join('\n'))
            end
          end.flatten
        end
      end
            
      csv_string = "\xEF\xBB\xBF#{csv_string}" if encoding_to == 'UTF-8'
      [!options[:skip_header], encoding_to, csv_string]
    end
    
    
    private 
    
    def output(str)
      (@iconv ? @iconv.conv(str.to_s) : str.to_s) rescue str
    end
  end
end

