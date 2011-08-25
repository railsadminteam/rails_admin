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
            klass.instance_variable_set("@view_helper", :text_field)
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

        def column_css_class(*args, &block)
          if !args[0].nil? || block
            @css_class = args[0].nil? ? block : args[0]
          else
            css_class
          end
        end

        register_instance_option(:column_width) do
          self.class.instance_variable_get("@column_width")
        end

        register_instance_option(:read_only) do
          false
        end

        register_instance_option(:truncated?) do
          ActiveSupport::Deprecation.warn("'#{self.name}.truncated?' is deprecated, use '#{self.name}.pretty_value' instead", caller)
        end

        register_instance_option(:sortable) do
          true
        end

        register_instance_option(:searchable) do
          true
        end

        register_instance_option(:queryable?) do
          !!searchable
        end

        register_instance_option(:filterable?) do
          !!searchable
        end

        register_instance_option(:search_operator) do
          @search_operator ||= RailsAdmin::Config.default_search_operator
        end

        # serials and dates are reversed in list, which is more natural (last modified items first).
        register_instance_option(:sort_reverse?) do
          false
        end

        # list of columns I should search for that field [{ :column => 'table_name.column', :type => field.type }, {..}]
        register_instance_option(:searchable_columns) do
          @searchable_columns ||= case self.searchable
          when true
            [{ :column => "#{self.abstract_model.model.table_name}.#{self.name}", :type => self.type }]
          when false
            []
          when :all # valid only for associations
            self.associated_model_config.list.fields.map { |f| { :column => "#{self.associated_model_config.abstract_model.model.table_name}.#{f.name}", :type => f.type } }
          else
            [self.searchable].flatten.map do |f|
              if f.is_a?(String) && f.include?('.')                            #  "table_name.attribute"
                @table_name, column_name = f.split '.'
                f = column_name.to_sym
              end

              field_name = f.is_a?(Hash) ? f.values.first : f

              abstract_model = if f.is_a?(Hash) && (f.keys.first.is_a?(Class) || f.keys.first.is_a?(String)) #  { Model => :attribute } || { "Model" => :attribute }
                AbstractModel.new(f.keys.first)
              elsif f.is_a?(Hash)                                            #  { :table_name => :attribute }
                @table_name = f.keys.first.to_s
                (self.association? ? self.associated_model_config.abstract_model : self.abstract_model)
              else                                                           #  :attribute
                (self.association? ? self.associated_model_config.abstract_model : self.abstract_model)
              end

              property = abstract_model.properties.find{ |p| p[:name] == field_name }
              raise ":#{field_name} attribute not found/not accessible on table :#{abstract_model.model.table_name}. \nPlease check '#{self.abstract_model.pretty_name}' configuration for :#{self.name} attribute." unless property
              { :column => "#{@table_name || abstract_model.model.table_name}.#{property[:name]}", :type => property[:type] }
            end
          end
        end

        register_instance_option(:formatted_value) do
          value.to_s
        end

        # output for pretty printing (show, list)
        register_instance_option(:pretty_value) do
          formatted_value
        end
        
        # output for printing in export view (developers beware: no bindings[:view] and no data!)
        register_instance_option(:export_value) do
          pretty_value
        end


        # Accessor for field's help text displayed below input field.
        register_instance_option(:help) do
          @help ||= (required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")) + '. '
        end

        register_instance_option(:html_attributes) do
          {
            :class => "#{css_class} #{has_errors? ? "errorField" : nil}",
            :value => value
          }.merge(column_width.present? ? { :style => "width:#{column_width}px" } : {})
        end

        # Accessor for field's label.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:label) do
          @label ||= abstract_model.model.human_attribute_name name
        end

        # Accessor for field's maximum length.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:length) do
          @length ||= properties && properties[:length]
        end

        register_instance_option(:partial) do
          :form_field
        end

        register_deprecated_instance_option(:show_partial, :partial) # deprecated on 2011-07-15
        register_deprecated_instance_option(:edit_partial, :partial) # deprecated on 2011-07-15
        register_deprecated_instance_option(:create_partial, :partial) # deprecated on 2011-07-15
        register_deprecated_instance_option(:update_partial, :partial) # deprecated on 2011-07-15

        register_instance_option(:render) do
          bindings[:view].render :partial => partial.to_s, :locals => {:field => self, :form => bindings[:form] }
        end

        # Accessor for whether this is field is mandatory.  This is
        # based on two factors: whether the field is nullable at the
        # database level, and whether it has an ActiveRecord validation
        # that requires its presence.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:required?) do
          @required ||= begin
            validators = abstract_model.model.validators_on(@name)
            required_by_validator = validators.find{|v| (v.class == ActiveModel::Validations::PresenceValidator) || (v.class == ActiveModel::Validations::NumericalityValidator && !v.options[:allow_nil])} && true || false
            properties && !properties[:nullable?] || required_by_validator
          end
        end

        # Accessor for whether this is a serial field (aka. primary key, identifier).
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:serial?) do
          properties && properties[:serial?]
        end

        register_instance_option(:view_helper) do
          @view_helper ||= self.class.instance_variable_get("@view_helper")
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

        # Reader for field's type
        def type
          @type ||= self.class.name.to_s.demodulize.underscore.to_sym
        end

        # Reader for field's value
        def value
          bindings[:object].safe_send(name)
        end

        # Reader for field's name
        def dom_name
          @dom_name ||= "#{bindings[:form].object_name}#{(index = bindings[:form].options[:index]) && "[#{index}]"}[#{method_name}]"
        end

        # Reader for field's id
        def dom_id
          @dom_id ||= [
            bindings[:form].object_name,
            bindings[:form].options[:index],
            method_name
          ].reject(&:blank?).join('_')
        end

        def method_name
          name
        end
      end
    end
  end
end
