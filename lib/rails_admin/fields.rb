require 'builder'

module RailsAdmin
  module Fields
    def self.extended(obj)
      # If field is object's native property
      if obj.abstract_model.properties.find {|f| obj.name == f[:name] }
        # Extend field with behaviour of it's data type
        obj.extend DataTypes.load(obj.type)
        
        # If field is a foreign key for a belongs to association
        if association = obj.abstract_model.belongs_to_associations.select{|a| a[:child_key].first == obj.name}.first
          # Store association data within field
          obj.instance_variable_set("@association", association)
          # Extend field with association behaviour
          obj.extend Associations
        
        # Otherwise it's a normal field
        else
          obj.extend Concrete
        end

      # If field is an association
      elsif association = obj.abstract_model.associations.select{|a| a[:parent_model] == obj.name}.first
        # Store association data within field
        obj.instance_variable_set("@association", association)
        # Extend field with association behaviour
        obj.extend Associations
      
      # Otherwise field is readable only (eg. is method of record object)
      else
        # Extend field with virtual field capabilities
        obj.extend Virtual
      end
    end

    # Concrete field mixin provides standard behaviour for a database column. Concrete field
    # can be found within abstract_model.properties and can deduct it's default capabilities
    # via that interface.
    module Concrete
      def self.extended(obj)
        # Accessor for field's label.
        #
        # @see RailsAdmin::AbstractModel.properties
        obj.register_instance_option(:label) do
          abstract_model.properties.find {|column| name == column[:name] }[:pretty_name]
        end

        # Accessor for field's maximum length.
        #
        # @see RailsAdmin::AbstractModel.properties
        obj.register_instance_option(:length) do
          abstract_model.properties.find {|column| name == column[:name] }[:length]
        end

        # Accessor for whether this is field is mandatory.
        #
        # @see RailsAdmin::AbstractModel.properties
        obj.register_instance_option(:required?) do
          abstract_model.properties.find {|column| name == column[:name]}[:nullable?]
        end

        # Accessor for whether this is a serial field (aka. primary key, identifier).
        #
        # @see RailsAdmin::AbstractModel.properties
        obj.register_instance_option(:serial?) do
          abstract_model.properties.find {|column| name == column[:name]}[:serial?]
        end

        # Accessor for field's value
        obj.register_instance_option(:value) do
          bindings[:object].send(name)
        end

        class << obj
          def partial
            type.to_s
          end
        end
      end
    end

    # Association field mixin provides behaviour for database associations. It can
    # can be found within abstract_model.associations and can deduct it's default capabilities
    # via that interface.
    module Associations
      def self.extended(obj)        
        # Define reader for association data
        def obj.association
          instance_variable_get("@association")
        end

        # Accessor for field's label.
        #
        # @see RailsAdmin::AbstractModel.properties
        obj.register_instance_option(:label) do
          association[:pretty_name]
        end

        # Accessor for whether this is field is required.
        #
        # @see RailsAdmin::AbstractModel.properties
        obj.register_instance_option(:required?) do
          false
        end

        # Accessor for whether this is field is searchable.
        obj.register_instance_option(:searchable?) do
          false
        end

        # Accessor for whether this is field is sortable.
        obj.register_instance_option(:sortable?) do
          false
        end        

        class << obj
          def associated_collection
            associated_model_config.abstract_model.all.map do |object|
              [associated_model_config.bind(:object, object).list.object_label, object.id]
            end
          end

          def associated_model_config
            @associated_model_config ||= RailsAdmin.config(association[:child_model])
          end
          
          def partial
            "#{association[:type]}_association"
          end
          
          def value
            bindings[:object].send(association[:name])
          end
        end
        
        # Extend field with correct association behaviour
        obj.extend "RailsAdmin::Fields::Associations::#{obj.association[:type].to_s.camelize}".constantize
      end
      
      module BelongsTo
        def self.extended(obj)
          # Accessor for field's maximum length.
          #
          # @see RailsAdmin::AbstractModel.properties
          obj.register_instance_option(:length) do
            abstract_model.properties.find {|column| name == column[:name] }[:length]
          end

          # Accessor for whether this is field is mandatory.
          #
          # @see RailsAdmin::AbstractModel.properties
          obj.register_instance_option(:required?) do
            abstract_model.properties.find {|column| name == column[:name]}[:nullable?]
          end

          # Accessor for whether this is a serial field (aka. primary key, identifier).
          #
          # @see RailsAdmin::AbstractModel.properties
          obj.register_instance_option(:serial?) do
            abstract_model.properties.find {|column| name == column[:name]}[:serial?]
          end

          # Accessor for field's formatted value 
          obj.register_instance_option(:formatted_value) do
            object = bindings[:object].send(association[:name])
            unless object.nil?
              RailsAdmin::Config.model(object).list.object_label
            else
              nil
            end
          end

          # Accessor for field's value
          obj.register_instance_option(:value) do
            bindings[:object].send(name)
          end
          
          class << obj
            def associated_collection
              associated_model_config.abstract_model.all.map do |object| 
                [associated_model_config.bind(:object, object).list.object_label, object.id]
              end
            end

            def associated_model_config
              @associated_model_config ||= RailsAdmin.config(association[:parent_model])
            end
          end
        end
      end
      
      module HasAndBelongsToMany
      end

      module HasAndBelongsToMany
      end

      module HasMany
      end

      module HasOne
      end
    end
    
    # Virtual field mixin provides behaviour for columns that are calculated at runtime
    # for example record object methods.
    module Virtual
      def self.extended(obj)
        # Accessor for field's label.
        obj.register_instance_option(:label) do
          name.to_s.underscore.gsub('_', ' ').capitalize
        end

        # Accessor for field's maximum length.
        obj.register_instance_option(:length) do
          100
        end

        # Reader for whether this is field is mandatory.
        obj.register_instance_option(:required?) do
          false
        end

        # Accessor for whether this is field is searchable.
        obj.register_instance_option(:searchable?) do
          false
        end

        # Reader for whether this is a serial field (aka. primary key, identifier).
        obj.register_instance_option(:serial?) do
          false
        end

        # Accessor for whether this is field is sortable.
        obj.register_instance_option(:sortable?) do
          false
        end              

        # Accessor for field's value
        obj.register_instance_option(:value) do
          bindings[:object].send(name)
        end
      end
    end

    # Provides default behaviour for various kinds of database columns based on
    # the datatype.
    module DataTypes
      @@registry = {}

      def self.register(type, klass)
        @@registry[type.to_sym] = klass
      end

      def self.load(type)
        @@registry[type.to_sym] or raise "Unsupported field datatype: #{type}"
      end

      module Boolean
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            "bool"
          end
          obj.register_instance_option(:column_width) do
            60
          end
          obj.register_instance_option(:searchable?) do
            false
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end
        end
      end

      module Date
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            "date"
          end
          obj.register_instance_option(:column_width) do
            90
          end
          obj.register_instance_option(:searchable?) do
            false
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            if value == true
              Builder::XmlMarkup.new.img(:src => bindings[:view].image_path("bullet_black.png"), :alt => "True").html_safe
            else
              Builder::XmlMarkup.new.img(:src => bindings[:view].image_path("bullet_white.png"), :alt => "False").html_safe
            end
          end
          obj.register_instance_option(:strftime_format) do
            "%b. %d, %Y"
          end
        end
      end

      module Datetime
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            "dateTime"
          end
          obj.register_instance_option(:column_width) do
            170
          end
          obj.register_instance_option(:searchable?) do
            false
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (time = value).nil?
              time.strftime(strftime_format)
            else
              "".html_safe
            end
          end
          obj.register_instance_option(:strftime_format) do
            "%b. %d, %Y, %I:%M%p"
          end
        end
      end

      module Decimal
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            "decimal"
          end
          obj.register_instance_option(:column_width) do
            110
          end
          obj.register_instance_option(:searchable?) do
            false
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end
        end
      end

      module Float
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            "float"
          end
          obj.register_instance_option(:column_width) do
            110
          end
          obj.register_instance_option(:searchable?) do
            false
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end
        end
      end

      module Integer
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            serial? ? "id" : "int"
          end
          obj.register_instance_option(:column_width) do
            serial? ? 46 : 80
          end
          obj.register_instance_option(:searchable?) do
            false
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end
        end
      end

      module String
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            length > 100 ? "bigString" : "smallString"
          end
          obj.register_instance_option(:column_width) do
            length > 100 ? 250 : 180
          end
          obj.register_instance_option(:searchable?) do
            true
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end
        end
      end
    
      module Text
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            "text"
          end
          obj.register_instance_option(:column_width) do
            250
          end
          obj.register_instance_option(:searchable?) do
            true
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end
        end
      end
  
      module Time
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            "time"
          end
          obj.register_instance_option(:column_width) do
            60
          end
          obj.register_instance_option(:searchable?) do
            false
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (time = value).nil?
              time.strftime(strftime_format)
            else
              "".html_safe
            end
          end
          obj.register_instance_option(:strftime_format) do
            "%I:%M%p"
          end
        end
      end
  
      module Timestamp
        def self.extended(obj)
          obj.register_instance_option(:column_css_class) do
            "dateTime"
          end
          obj.register_instance_option(:column_width) do
            170
          end
          obj.register_instance_option(:searchable?) do
            false
          end
          obj.register_instance_option(:sortable?) do
            true
          end
          obj.register_instance_option(:formatted_value) do
            unless (time = value).nil?
              time.strftime(strftime_format)
            else
              "".html_safe
            end
          end
          obj.register_instance_option(:strftime_format) do
            "%b. %d, %Y, %I:%M%p"
          end
        end
      end

      constants.each do |it|
        @@registry[it.to_s.underscore.to_sym] = "RailsAdmin::Fields::DataTypes::#{it}".constantize
      end
    end
  end
end