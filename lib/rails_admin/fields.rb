require 'builder'

module RailsAdmin
  module Fields
    module Groupable
      # A container for groups of fields in edit views
      class Group < RailsAdmin::Config::Configurable
        include RailsAdmin::Config::Hideable

        attr_reader :name

        def initialize(parent, name)
          super(parent)
          @name = name
        end

        def fields
          parent.fields.select {|f| self == f.group }
        end

        def visible_fields
          fields.select {|f| f.visible? }
        end

        register_instance_option(:label) do
          name.to_s.underscore.gsub('_', ' ').capitalize
        end
      end

      def self.extended(obj)
        obj.instance_variable_set("@group", obj.parent.group(:default))
        class << obj
          def group=(name)
            group(name)
          end
          def group(name = nil)
            @group = parent.group(name) unless name.nil?
            @group
          end
        end
      end

      def self.included(klass)
        # Access fields by their group
        klass.send(:define_method, :fields_of_group) do |group, &block|
          selected = @fields.select {|f| group == f.group }
          if block
            selected.each {|f| f.instance_eval &block }
          end
          selected
        end
        klass.send(:define_method, :group) do |name, &block|
          group = @groups.find {|g| name == g.name }
          if group.nil?
            group = (@groups << Group.new(self, name)).last
          end
          group.instance_eval &block if block
          group
        end
        klass.send(:define_method, :groups) do
          @groups
        end
        klass.send(:define_method, :visible_groups) do
          groups.select {|g| g.visible? }
        end
      end
    end

    mattr_reader :default_factory
    @@default_factory = lambda do |parent, properties, fields|
      if properties.has_key?(:parent_model)
        if :belongs_to == properties[:type]
          association = properties
          properties = parent.abstract_model.properties.find {|p| association[:child_key].first == p[:name]}
          fields << Types.load("belongs_to_association").new(parent, properties[:name], properties, association)
        else
          fields << Types.load("#{properties[:type]}_association").new(parent, properties[:name], properties)
        end
      else
        fields << Types.load(properties[:type]).new(parent, properties[:name], properties)
      end
    end

    @@registry = [@@default_factory]

    def self.factory(parent)
      fields = []

      parent.abstract_model.associations.each do |association|
        unless fields.find {|f| f.name == association[:name] }
          @@registry.find {|factory| factory.call(parent, association, fields) }
        end
      end

      parent.abstract_model.properties.each do |properties|
        unless fields.find {|f| f.name == properties[:name] }
          @@registry.find {|factory| factory.call(parent, properties, fields) }
        end
      end

      fields
    end

    def self.register_factory(&block)
      @@registry.unshift(block)
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

        if parent.kind_of?(RailsAdmin::Fields::Groupable)
          extend RailsAdmin::Fields::Groupable
        end
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

      # Accessor for whether this is field is mandatory.  This is
      # based on two factors: whether the field is nullable at the
      # database level, and whether it has an ActiveRecord validation
      # that requires its presence.
      #
      # @see RailsAdmin::AbstractModel.properties
      register_instance_option(:required?) do
        validators = abstract_model.model.validators_on(@name)
        required_by_validator = validators.find{|v| (v.class == ActiveModel::Validations::PresenceValidator) || (v.class == ActiveModel::Validations::NumericalityValidator && v.options[:allow_nil]==false)} && true || false
        !properties[:nullable?] || required_by_validator
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

      # Reader whether field is optional.
      #
      # @see RailsAdmin::Fields::Field.register_instance_option(:required?)
      def optional?
        not required
      end

      # Inverse accessor whether this field is required.
      #
      # @see RailsAdmin::Fields::Field.register_instance_option(:required?)
      def optional(state = nil, &block)
        if !state.nil? || block
          required state.nil? ? proc { false == (instance_eval &block) } : false == state
        else
          optional?
        end
      end

      # Writer to make field optional.
      #
      # @see RailsAdmin::Fields::Field.optional
      def optional=(state)
        optional(state)
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

      register_instance_option(:visible?) do |p|
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
        bindings[:object].errors[child_key]
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

      def self.load(type)
        @@registry[type.to_sym] or raise "Unsupported field datatype: #{type}"
      end

      def self.register(type, klass)
        @@registry[type.to_sym] = klass
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

      class Password < String
        @column_names = [:password]

        def self.column_names
          @column_names
        end

        # Register a custom field factory for fields named as password. More
        # field names can be registered to the column_names array
        #
        # @see RailsAdmin::Fields::Types::Password.column_names
        # @see RailsAdmin::Fields.register_factory
        RailsAdmin::Fields.register_factory do |parent, properties, fields|
          if @column_names.include?(properties[:name])
            fields << self.new(parent, properties[:name], properties)
            true
          else
            false
          end
        end

        def initialize(parent, name, properties)
          super(parent, name, properties)
          hide if parent.kind_of?(RailsAdmin::Config::Sections::List)
        end

        register_instance_option(:formatted_value) do
          "".html_safe
        end

        register_instance_option(:searchable?) do
          false
        end

        register_instance_option(:sortable?) do
          false
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
        register_instance_option(:column_css_class) do
          "smallString"
        end

        register_instance_option(:column_width) do
          180
        end

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

      # Register a custom field factory for devise model if Devise is defined
      if defined?(::Devise)
        RailsAdmin::Fields.register_factory do |parent, properties, fields|
          if :encrypted_password == properties[:name]
            fields << RailsAdmin::Fields::Types.load(:password).new(parent, :password, properties)
            fields.last.label "Password"
            fields << RailsAdmin::Fields::Types.load(:password).new(parent, :password_confirmation, properties)
            fields.last.label "Password confirmation"
            fields[-2..-1].each do |f|
              f.class.send(:define_method, :value) { "" }
            end
            [:password_salt, :reset_password_token, :remember_token].each do |name|
              properties = parent.abstract_model.properties.find {|p| name == p[:name]}
              if properties
                RailsAdmin::Fields.default_factory.call(parent, properties, fields)
                fields.last.hide
              end
            end
            if parent.kind_of?(RailsAdmin::Config::Sections::Update)
              [:remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip].each do |name|
                properties = parent.abstract_model.properties.find {|p| name == p[:name]}
                if properties
                  RailsAdmin::Fields.default_factory.call(parent, properties, fields)
                  fields.last.hide
                end
              end
            end
            true
          else
            false
          end
        end
      end
    end
  end
end
