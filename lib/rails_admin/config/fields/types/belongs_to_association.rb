require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BelongsToAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          # Accessor for field's formatted value
          register_instance_option :formatted_value do
            (o = value) && o.send(associated_model_config.object_label_method)
          end

          # we need to check for validation on field and association
          register_instance_option :required? do
            @required ||= !!(abstract_model.model.validators_on(name) + abstract_model.model.validators_on(method_name)).find do |v|
              v.is_a?(ActiveModel::Validations::PresenceValidator) && !v.options[:allow_nil] ||
              v.is_a?(ActiveModel::Validations::NumericalityValidator) && !v.options[:allow_nil]
            end
          end

          register_instance_option :sortable do
            @sortable ||= associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? associated_model_config.object_label_method : {self.abstract_model.model.name => self.method_name}
          end

          register_instance_option :searchable do
            @searchable ||= associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? [associated_model_config.object_label_method, {self.abstract_model.model.name => self.method_name}] : {self.abstract_model.model.name => self.method_name}
          end

          register_instance_option :partial do
            nested_form ? :form_nested_one : :form_filtering_select
          end

          def associated_model_config
            @config ||= RailsAdmin.config(association[:parent_model])
          end

          def selected_id
            bindings[:object].send(child_key)
          end

          def method_name
            nested_form ? "#{association[:child_key]}_attributes" : association[:child_key]
          end
        end
      end
    end
  end
end
