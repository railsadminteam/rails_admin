require 'builder'

module RailsAdmin
  module Fields

    def self.factory(parent, name, type, properties = [])
      if association = parent.abstract_model.belongs_to_associations.select{|a| a[:child_key].first == name}.first
        field = Types.load("belongs_to_association").new(parent, name, properties, association)
      else
        field = Types.load(type).new(parent, name, properties)
      end
      field
    end

    class Field < RailsAdmin::Config::Configurable

      attr_reader :name, :properties
      attr_accessor :defined, :order

      include RailsAdmin::Config::Hideable

      def initialize(parent, name, properties)
        super(parent)
        @defined = false
        @name = name
        @order = 0
        @properties = properties
      end

      # Accessor for field's help text displayed below input field.
      register_instance_option(:help) do
        required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")
      end

      # Accessor for field's label.
      #
      # @see RailsAdmin::AbstractModel.properties
      register_instance_option(:label) do
        properties[:pretty_name]
      end

      # Accessor for field's maximum length.
      #
      # @see RailsAdmin::AbstractModel.properties
      register_instance_option(:length) do
        properties[:length]
      end

      register_instance_option(:partial) do
        type
      end

      # Accessor for whether this is field is mandatory.
      #
      # @see RailsAdmin::AbstractModel.properties
      register_instance_option(:required?) do
        !properties[:nullable?]
      end

      # Accessor for whether this is a serial field (aka. primary key, identifier).
      #
      # @see RailsAdmin::AbstractModel.properties
      register_instance_option(:serial?) do
        properties[:serial?]
      end

      def association?
        kind_of?(RailsAdmin::Fields::Association)
      end

      def errors
        bindings[:object].errors[name]
      end

      def has_errors?
        !(bindings[:object].errors[name].nil? || bindings[:object].errors[name].empty?)
      end

      def to_hash
        {
          :name => name,
          :pretty_name => label,
          :type => type,
          :length => length,
          :nullable? => required?,
          :searchable? => searchable?,
          :serial? => serial?,
          :sortable? => sortable?,
        }
      end

      def type
        @type ||= self.class.name.split("::").last.underscore.to_sym
      end

      # Reader for field's value
      def value
        bindings[:object].send(name)
      end
    end

    class Association < Field

      def association
        @properties
      end

      # Accessor for field's label.
      #
      # @see RailsAdmin::AbstractModel.properties
      register_instance_option(:label) do
        association[:pretty_name]
      end

      # Accessor for whether this is field is required.
      #
      # @see RailsAdmin::AbstractModel.properties
      register_instance_option(:required?) do
        false
      end

      # Accessor for whether this is field is searchable.
      register_instance_option(:searchable?) do
        false
      end

      # Accessor for whether this is field is sortable.
      register_instance_option(:sortable?) do
        false
      end

      register_instance_option(:visible?) do
        !associated_model_config.excluded?
      end

      def associated_collection
        associated_model_config.abstract_model.all.map do |object|
          [associated_model_config.bind(:object, object).list.object_label, object.id]
        end
      end

      def associated_model_config
        @associated_model_config ||= RailsAdmin.config(association[:child_model])
      end

      def child_key
        association[:child_key].first
      end

      def child_keys
        association[:child_key]
      end

      def errors
        bindings[:object].errors[association[:child_key]]
      end

      def has_errors?
        !(bindings[:object].errors[child_key].nil? || bindings[:object].errors[child_key].empty?)
      end

      def value
        bindings[:object].send(association[:name])
      end
    end

    module Types

      @@registry = {}

      def self.register(type, klass)
        @@registry[type.to_sym] = klass
      end

      def self.load(type)
        @@registry[type.to_sym] or raise "Unsupported field datatype: #{type}"
      end

      class BelongsToAssociation < RailsAdmin::Fields::Association

        attr_reader :association

        def initialize(parent, name, properties, association)
          super(parent, name, properties)
          @association = association
        end

        register_instance_option(:column_css_class) do
          "bigString"
        end

        register_instance_option(:column_width) do
          250
        end

        # Accessor for field's maximum length.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:length) do
          properties[:length]
        end

        # Accessor for whether this is field is mandatory.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:required?) do
          properties[:nullable?]
        end

        # Accessor for whether this is a serial field (aka. primary key, identifier).
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:serial?) do
          properties[:serial?]
        end

        # Accessor for field's formatted value
        register_instance_option(:formatted_value) do
          object = bindings[:object].send(association[:name])
          unless object.nil?
            RailsAdmin::Config.model(object).list.object_label
          else
            nil
          end
        end

        def associated_collection
          associated_model_config.abstract_model.all.map do |object|
            [associated_model_config.bind(:object, object).list.object_label, object.id]
          end
        end

        def associated_model_config
          @associated_model_config ||= RailsAdmin.config(association[:parent_model])
        end

        # Reader for field's value
        def value
          bindings[:object].send(name)
        end
      end

      class HasAndBelongsToManyAssociation < RailsAdmin::Fields::Association
        # Accessor for field's help text displayed below input field.
        register_instance_option(:help) do
          ""
        end
      end

      class HasManyAssociation < RailsAdmin::Fields::Association
        # Accessor for field's help text displayed below input field.
        register_instance_option(:help) do
          ""
        end
      end

      class HasOneAssociation < RailsAdmin::Fields::Association
      end

      class Boolean < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          "bool"
        end

        register_instance_option(:column_width) do
          60
        end

        register_instance_option(:formatted_value) do
          if value == true
            Builder::XmlMarkup.new.img(:src => bindings[:view].image_path("bullet_black.png"), :alt => "True").html_safe
          else
            Builder::XmlMarkup.new.img(:src => bindings[:view].image_path("bullet_white.png"), :alt => "False").html_safe
          end
        end

        # Accessor for field's help text displayed below input field.
        register_instance_option(:help) do
          ""
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          true
        end
      end

      class Date < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          "date"
        end

        register_instance_option(:column_width) do
          90
        end

        register_instance_option(:formatted_value) do
          unless (time = value).nil?
            time.strftime(strftime_format)
          else
            "".html_safe
          end
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          true
        end

        register_instance_option(:strftime_format) do
          "%b. %d, %Y"
        end
      end

      class Datetime < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          "dateTime"
        end

        register_instance_option(:column_width) do
          170
        end

        register_instance_option(:formatted_value) do
          unless (time = value).nil?
            time.strftime(strftime_format)
          else
            "".html_safe
          end
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          true
        end

        register_instance_option(:strftime_format) do
          "%b. %d, %Y, %I:%M%p"
        end
      end

      class Decimal < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          "float"
        end

        register_instance_option(:column_width) do
          110
        end

        register_instance_option(:formatted_value) do
          unless (output = value).nil?
            output
          else
            "".html_safe
          end
        end

        register_instance_option(:partial) do
          "float"
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          true
        end
      end

      class Float < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          "float"
        end

        register_instance_option(:column_width) do
          110
        end

        register_instance_option(:formatted_value) do
          unless (output = value).nil?
            output
          else
            "".html_safe
          end
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          true
        end
      end

      class Integer < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          serial? ? "id" : "int"
        end

        register_instance_option(:column_width) do
          serial? ? 46 : 80
        end

        register_instance_option(:formatted_value) do
          unless (output = value).nil?
            output
          else
            "".html_safe
          end
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          true
        end
      end

      class String < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          length > 100 ? "bigString" : "smallString"
        end

        register_instance_option(:column_width) do
          length > 100 ? 250 : 180
        end

        register_instance_option(:formatted_value) do
          unless (output = value).nil?
            output
          else
            "".html_safe
          end
        end

        # Accessor for field's help text displayed below input field.
        register_instance_option(:help) do
          text = required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")
          text += " #{length} "
          text += length == 1 ? I18n.translate("admin.new.one_char") : I18n.translate("admin.new.many_chars")
          text
        end

        register_instance_option(:searchable?) do
          true
        end

        register_instance_option(:sortable?) do
          true
        end
      end

      class Text < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          "text"
        end

        register_instance_option(:column_width) do
          250
        end

        register_instance_option(:formatted_value) do
          unless (output = value).nil?
            output
          else
            "".html_safe
          end
        end

        register_instance_option(:searchable?) do
          true
        end

        register_instance_option(:sortable?) do
          true
        end
      end

      class Time < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          "time"
        end

        register_instance_option(:column_width) do
          60
        end

        register_instance_option(:formatted_value) do
          unless (time = value).nil?
            time.strftime(strftime_format)
          else
            "".html_safe
          end
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          true
        end

        register_instance_option(:strftime_format) do
          "%I:%M%p"
        end
      end

      class Timestamp < RailsAdmin::Fields::Field
        register_instance_option(:column_css_class) do
          "dateTime"
        end

        register_instance_option(:column_width) do
          170
        end

        register_instance_option(:formatted_value) do
          unless (time = value).nil?
            time.strftime(strftime_format)
          else
            "".html_safe
          end
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          true
        end

        register_instance_option(:strftime_format) do
          "%b. %d, %Y, %I:%M%p"
        end
      end

      # Virtual field mixin provides behaviour for columns that are calculated at runtime
      # for example record object methods.
      class Virtual < RailsAdmin::Fields::Field
        register_instance_option(:formatted_value) do
          unless (output = value).nil?
            output
          else
            "".html_safe
          end
        end

        # Accessor for field's label.
        register_instance_option(:label) do
          name.to_s.underscore.gsub('_', ' ').capitalize
        end

        # Accessor for field's maximum length.
        register_instance_option(:length) do
          100
        end

        # Reader for whether this is field is mandatory.
        register_instance_option(:required?) do
          false
        end

        # Accessor for whether this is field is searchable.
        register_instance_option(:searchable?) do
          false
        end

        # Reader for whether this is a serial field (aka. primary key, identifier).
        register_instance_option(:serial?) do
          false
        end

        # Accessor for whether this is field is sortable.
        register_instance_option(:sortable?) do
          false
        end

        # Reader for field's value
        def value
          bindings[:object].send(name)
        end
      end

      constants.each do |it|
        @@registry[it.to_s.underscore.to_sym] = "RailsAdmin::Fields::Types::#{it}".constantize
      end
    end
  end
end