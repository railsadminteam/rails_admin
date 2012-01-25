require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/fields'
require 'rails_admin/config/fields/association'
require 'rails_admin/config/fields/groupable'


module RailsAdmin
  module Config
    module Fields
      class Base < RailsAdmin::Config::Base
        attr_reader :name, :properties
        attr_accessor :defined, :order, :section

        def self.inherited(klass)
          klass.instance_variable_set("@view_helper", :text_field)
        end

        include RailsAdmin::Config::Hideable

        def initialize(parent, name, properties)
          super(parent)
          
          @defined = false
          @name = name
          @order = 0
          @properties = properties
          @section = parent
          
          extend RailsAdmin::Config::Fields::Groupable
        end

        register_instance_option(:css_class) do
          "#{self.name}_field"
        end
        
        def type_css_class
          "#{type}_type"
        end
        
        def virtual?
          properties.blank?
        end

        register_instance_option(:column_width) do
          nil
        end
        
        register_instance_option(:sortable) do
          !virtual?
        end

        register_instance_option(:searchable) do
          !virtual?
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
            table_name = self.associated_model_config.abstract_model.model.table_name
            self.associated_model_config.list.fields.map { |f| { :column => "#{table_name}.#{f.name}", :type => f.type } }
          else
            [self.searchable].flatten.map do |f|
              if f.is_a?(String) && f.include?('.')                            #  table_name.column
                table_name, column = f.split '.'
                type = nil
              elsif f.is_a?(Hash)                                              #  <Model|table_name> => <attribute|column>
                am = f.keys.first.is_a?(Class) && AbstractModel.new(f.keys.first)
                table_name = am && am.model.table_name || f.keys.first
                column = f.values.first
                property = am && am.properties.find{ |p| p[:name] == f.values.first.to_sym }
                type = property && property[:type]
              else                                                             #  <attribute|column>
                am = (self.association? ? self.associated_model_config.abstract_model : self.abstract_model)
                table_name = am.model.table_name
                column = f
                property = am.properties.find{ |p| p[:name] == f.to_sym }
                type = property && property[:type]
              end

              { :column => "#{table_name}.#{column}", :type => (type || :string) }
            end
          end
        end

        register_instance_option(:formatted_value) do
          value.to_s
        end

        # output for pretty printing (show, list)
        register_instance_option(:pretty_value) do
          formatted_value.presence || ' - '
        end

        # output for printing in export view (developers beware: no bindings[:view] and no data!)
        register_instance_option(:export_value) do
          pretty_value
        end


        # Accessor for field's help text displayed below input field.
        register_instance_option(:help) do
          (@help ||= {})[::I18n.locale] ||= (required? ? I18n.translate("admin.form.required") : I18n.translate("admin.form.optional")) + '. '
        end

        register_instance_option(:html_attributes) do
          {}
        end
        
        register_instance_option :default_value do
          nil
        end

        # Accessor for field's label.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:label) do
          (@label ||= {})[::I18n.locale] ||= abstract_model.model.human_attribute_name name
        end

        # Accessor for field's maximum length per database.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:length) do
          @length ||= properties && properties[:length]
        end

        # Accessor for field's length restrictions per validations
        #
        register_instance_option(:valid_length) do
          @valid_length ||= abstract_model.model.validators_on(name).find{|v|
            v.is_a?(ActiveModel::Validations::LengthValidator)}.try{|v| v.options} || {}
        end

        register_instance_option(:partial) do
          :form_field
        end

        # Accessor for whether this is field is mandatory.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:required?) do
          @required ||= !!abstract_model.model.validators_on(name).find do |v|
            v.is_a?(ActiveModel::Validations::PresenceValidator) && !v.options[:allow_nil] ||
            v.is_a?(ActiveModel::Validations::NumericalityValidator) && !v.options[:allow_nil]
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
        
        register_instance_option :read_only do
          not editable
        end
        
        register_instance_option :visible? do
          returned = true
          (RailsAdmin.config.default_hidden_fields || {}).each do |section, fields|
            if self.section.is_a?("RailsAdmin::Config::Sections::#{section.to_s.camelize}".constantize)
              returned = false if fields.include?(self.name)
            end
          end
          returned
        end
        
        def editable
          return false if @properties && @properties[:read_only]
          role = bindings[:view].controller.send(:_attr_accessible_role)
          klass = bindings[:object].class
          whitelist = klass.accessible_attributes(role).map(&:to_s)
          blacklist = klass.protected_attributes(role).map(&:to_s)
          !self.method_name.to_s.in?(blacklist) && (whitelist.any? ? self.method_name.to_s.in?(whitelist) : true)
        end
        
        def render
          bindings[:view].render :partial => partial.to_s, :locals => {:field => self, :form => bindings[:form] }
        end

        # Is this an association
        def association?
          kind_of?(RailsAdmin::Config::Fields::Association)
        end

        # Reader for validation errors of the bound object
        def errors
          bindings[:object].errors[name]
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
        
        # Reader for nested attributes
        register_instance_option :nested_form do
          false
        end
        
        def inverse_of
          nil
        end

        def method_name
          name
        end
        
        def html_default_value
          bindings[:object].new_record? && self.value.nil? && !self.default_value.nil? ? self.default_value : nil
        end
      end
    end
  end
end
