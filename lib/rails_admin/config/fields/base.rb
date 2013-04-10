require 'rails_admin/config/proxyable'
require 'rails_admin/config/configurable'
require 'rails_admin/config/hideable'
require 'rails_admin/config/groupable'

module RailsAdmin
  module Config
    module Fields
      class Base
        include RailsAdmin::Config::Proxyable
        include RailsAdmin::Config::Configurable
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Groupable

        attr_reader :name, :properties, :abstract_model
        attr_accessor :defined, :order, :section
        attr_reader :parent, :root

        def initialize(parent, name, properties)
          @parent = parent
          @root = parent.root

          @abstract_model = parent.abstract_model
          @defined = false
          @name = name.to_sym
          @order = 0
          @properties = properties
          @section = parent
        end

        register_instance_option :css_class do
          "#{self.name}_field"
        end

        def type_css_class
          "#{type}_type"
        end

        def virtual?
          properties.blank?
        end

        register_instance_option :column_width do
          nil
        end

        register_instance_option :sortable do
          !virtual? || children_fields.first || false
        end

        register_instance_option :searchable do
          !virtual? || children_fields.first || false
        end

        register_instance_option :queryable? do
          !virtual?
        end

        register_instance_option :filterable? do
          !!searchable
        end

        register_instance_option :search_operator do
          @search_operator ||= RailsAdmin::Config.default_search_operator
        end

        # serials and dates are reversed in list, which is more natural (last modified items first).
        register_instance_option :sort_reverse? do
          false
        end

        # list of columns I should search for that field [{ :column => 'table_name.column', :type => field.type }, {..}]
        register_instance_option :searchable_columns do
          @searchable_columns ||= case self.searchable
          when true
            [{ :column => "#{self.abstract_model.table_name}.#{self.name}", :type => self.type }]
          when false
            []
          when :all # valid only for associations
            table_name = self.associated_model_config.abstract_model.table_name
            self.associated_model_config.list.fields.map { |f| { :column => "#{table_name}.#{f.name}", :type => f.type } }
          else
            [self.searchable].flatten.map do |f|
              if f.is_a?(String) && f.include?('.')                            #  table_name.column
                table_name, column = f.split '.'
                type = nil
              elsif f.is_a?(Hash)                                              #  <Model|table_name> => <attribute|column>
                am = f.keys.first.is_a?(Class) && AbstractModel.new(f.keys.first)
                table_name = am && am.table_name || f.keys.first
                column = f.values.first
                property = am && am.properties.find{ |p| p[:name] == f.values.first.to_sym }
                type = property && property[:type]
              else                                                             #  <attribute|column>
                am = (self.association? ? self.associated_model_config.abstract_model : self.abstract_model)
                table_name = am.table_name
                column = f
                property = am.properties.find{ |p| p[:name] == f.to_sym }
                type = property && property[:type]
              end

              { :column => "#{table_name}.#{column}", :type => (type || :string) }
            end
          end
        end

        register_instance_option :formatted_value do
          value.to_s
        end

        # output for pretty printing (show, list)
        register_instance_option :pretty_value do
          formatted_value.presence || ' - '
        end

        # output for printing in export view (developers beware: no bindings[:view] and no data!)
        register_instance_option :export_value do
          pretty_value
        end


        # Accessor for field's help text displayed below input field.
        register_instance_option :help do
          (@help ||= {})[::I18n.locale] ||= (required? ? I18n.translate("admin.form.required") : I18n.translate("admin.form.optional")) + '. '
        end

        register_instance_option :html_attributes do
          {}
        end

        register_instance_option :default_value do
          nil
        end

        # Accessor for field's label.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option :label do
          (@label ||= {})[::I18n.locale] ||= abstract_model.model.human_attribute_name name
        end

        register_instance_option :hint do
          (@hint ||= "")
        end

        # Accessor for field's maximum length per database.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option :length do
          @length ||= properties && properties[:length]
        end

        # Accessor for field's length restrictions per validations
        #
        register_instance_option :valid_length do
          @valid_length ||= abstract_model.model.validators_on(name).find{|v|
            v.kind == :length }.try{|v| v.options} || {}
        end

        register_instance_option :partial do
          :form_field
        end

        # Accessor for whether this is field is mandatory.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option :required? do
          context = (bindings && bindings[:object] ? (bindings[:object].persisted? ? :update : :create) : :nil)
          (@required ||= {})[context] ||= !!([name] + children_fields).uniq.find do |column_name|
            !!abstract_model.model.validators_on(column_name).find do |v|
              !v.options[:allow_nil] and
              [:presence, :numericality, :attachment_presence].include?(v.kind) and
              (v.options[:on] == context or v.options[:on].blank?)
            end
          end
        end

        # Accessor for whether this is a serial field (aka. primary key, identifier).
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option :serial? do
          properties && properties[:serial?]
        end

        register_instance_option :view_helper do
          :text_field
        end

        register_instance_option :read_only? do
          not editable?
        end

        # init status in the view
        register_instance_option :active? do
          false
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

        # columns mapped (belongs_to, paperclip, etc.). First one is used for searching/sorting by default
        register_instance_option :children_fields do
          []
        end

        register_instance_option :render do
          bindings[:view].render :partial => "rails_admin/main/#{partial}", :locals => {:field => self, :form => bindings[:form] }
        end

        def editable?
          return false if @properties && @properties[:read_only]
          role = bindings[:view].controller.send(:_attr_accessible_role)
          active_model_attr_accessible = !bindings[:object].class.active_authorizer[role].deny?(self.method_name)

          return true if active_model_attr_accessible
          if RailsAdmin::Config.yell_for_non_accessible_fields
            accessible = "attr_accessible :#{self.method_name}#{role == :default ? '' : ", :as => :#{role}"}"

            Rails.logger.debug <<-MESSAGE.strip_heredoc


            [RailsAdmin] Please add '#{accessible}' in your '#{bindings[:object].class}' model definition if you want to make it editable.
            You can also explicitely mark this field as read-only:

            config.model #{bindings[:object].class} do
              field :#{self.name} do
                read_only true
              end
            end

            Add 'config.yell_for_non_accessible_fields = false' in your 'rails_admin.rb' initializer if you do not want to see these warnings

            MESSAGE
          end
          false
        end

        # Is this an association
        def association?
          kind_of?(RailsAdmin::Config::Fields::Association)
        end

        # Reader for validation errors of the bound object
        def errors
          ([name] + children_fields).uniq.map do |column_name|
            bindings[:object].errors[column_name]
          end.uniq.flatten
        end

        # Reader whether field is optional.
        #
        # @see RailsAdmin::Config::Fields::Base.register_instance_option :required?
        def optional?
          not required?
        end

        # Inverse accessor whether this field is required.
        #
        # @see RailsAdmin::Config::Fields::Base.register_instance_option :required?
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

        # Allowed methods for the field in forms
        register_instance_option :allowed_methods do
          [method_name]
        end

        def parse_input(params)
          # overriden
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


        def inspect
          "#<#{self.class.name}[#{name}] #{
            instance_variables.map do |v|
              value = instance_variable_get(v)
              if [:@parent, :@root, :@section, :@children_fields_registered,
                  :@associated_model_config, :@group, :@bindings].include? v
                if value.respond_to? :name
                  "#{v}=#{value.name.inspect}"
                else
                  "#{v}=#{value.class.name}"
                end
              else
                "#{v}=#{value.inspect}"
              end
            end.join(", ")
          }>"
        end
      end
    end
  end
end
