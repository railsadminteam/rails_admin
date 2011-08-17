require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BelongsToAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          # Accessor for field's formatted value
          register_instance_option(:formatted_value) do
            (o = value) && o.send(associated_model_config.object_label_method)
          end

          # we need to check for validation on field and association
          register_instance_option(:required?) do
            # todo unify errors for the form (see redmine)
            @required ||= begin
              key_properties = abstract_model.properties.find{|p| p[:name] == method_name}
              key_validators = abstract_model.model.validators_on(method_name)
              validators = abstract_model.model.validators_on(name)
              key_required_by_validator = key_validators.find{|v| (v.class == ActiveModel::Validations::PresenceValidator) || (v.class == ActiveModel::Validations::NumericalityValidator && !v.options[:allow_nil])} && true || false
              required_by_validator = validators.find{|v| (v.class == ActiveModel::Validations::PresenceValidator) || (v.class == ActiveModel::Validations::NumericalityValidator && !v.options[:allow_nil])} && true || false
              key_properties && !key_properties[:nullable?] || key_required_by_validator || required_by_validator
            end
          end

          register_instance_option(:sortable) do
            @sortable ||= associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? associated_model_config.object_label_method : {self.abstract_model.model.name => self.method_name}
          end

          register_instance_option(:searchable) do
            @searchable ||= associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? [associated_model_config.object_label_method, {self.abstract_model.model.name => self.method_name}] : {self.abstract_model.model.name => self.method_name}
          end

          register_instance_option(:partial) do
            :form_filtering_select
          end

          def associated_model_config
            @config ||= RailsAdmin.config(association[:parent_model])
          end

          def selected_id
            bindings[:object].send(child_key)
          end

          def method_name
            association[:child_key]
          end
        end
      end
    end
  end
end
