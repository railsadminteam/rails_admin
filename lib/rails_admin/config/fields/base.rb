require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/has_groups'
require 'rails_admin/config/fields'
require 'rails_admin/config/fields/groupable'
require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      class Base < RailsAdmin::Config::Base
        attr_reader :name, :properties
        attr_accessor :defined, :order

        def self.inherited(klass)
            klass.instance_variable_set("@css_class", klass.name.to_s.demodulize.camelcase(:lower))
            klass.instance_variable_set("@searchable", false)
            klass.instance_variable_set("@sortable", true)
        end

        include RailsAdmin::Config::Hideable

        def initialize(parent, name, properties)
          super(parent)

          @defined = false
          @name = name
          @order = 0
          @properties = properties

          # If parent is able to group fields the field should be aware of it
          if parent.kind_of?(RailsAdmin::Config::HasGroups)
            extend RailsAdmin::Config::Fields::Groupable
          end
        end

        register_instance_option(:css_class) do
          self.class.instance_variable_get("@css_class")
        end

        # NOTE: "css_class_name" is deprecated, use "css_class" instead.
        # FIXME: remove this after giving people an appropriate time
        # to change their code.
        def column_css_class(*args, &block)
          if !args[0].nil? || block
            @css_class = args[0].nil? ? block : args[0]
          else
            css_class
          end
        end

        # NOTE: "css_class_name" is deprecated, use "css_class" instead.
        # FIXME: remove this after giving people an appropriate time
        # to change their code.
        def column_css_class=(value)
          @css_class = value
        end

        register_instance_option(:column_width) do
          self.class.instance_variable_get("@column_width")
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
          required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")
        end

        # Accessor for field's label.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:label) do
          abstract_model.model.human_attribute_name name
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

        register_instance_option(:render) do
          bindings[:view].render :partial => partial.to_s, :locals => {:field => self}
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

        register_instance_option(:searchable?) do
          self.class.instance_variable_get("@searchable")
        end

        # Accessor for whether this is a serial field (aka. primary key, identifier).
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:serial?) do
          properties[:serial?]
        end

        register_instance_option(:sortable?) do
          self.class.instance_variable_get("@sortable")
        end

        # Is this an association
        def association?
          kind_of?(RailsAdmin::Config::Fields::Association)
        end

        # Reader for validation errors of the bound object
        def errors
          bindings[:object].errors[name]
        end

        # Reader whether the bound object has validation errors
        def has_errors?
          !(bindings[:object].errors[name].nil? || bindings[:object].errors[name].empty?)
        end

        # Reader whether field is optional.
        #
        # @see RailsAdmin::Config::Fields::Base.register_instance_option(:required?)
        def optional?
          not required
        end

        # Inverse accessor whether this field is required.
        #
        # @see RailsAdmin::Config::Fields::Base.register_instance_option(:required?)
        def optional(state = nil, &block)
          if !state.nil? || block
            required state.nil? ? proc { false == (instance_eval &block) } : false == state
          else
            optional?
          end
        end

        # Writer to make field optional.
        #
        # @see RailsAdmin::Config::Fields::Base.optional
        def optional=(state)
          optional(state)
        end

        # Legacy support
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

        # Reader for field's type
        def type
          @type ||= self.class.name.to_s.demodulize.underscore.to_sym
        end

        # Reader for field's value
        def value
          bindings[:object].send(name)
        end
      end
    end
  end
end
