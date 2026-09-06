# frozen_string_literal: true

require 'rails_admin/config/fields/singular_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BelongsToAssociation < RailsAdmin::Config::Fields::SingularAssociation
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :sortable do
            @sortable ||= abstract_model.adapter_supports_joins? && associated_model_config.abstract_model.properties.collect(&:name).include?(associated_model_config.object_label_method) ? associated_model_config.object_label_method : {abstract_model.table_name => method_name}
          end

          register_instance_option :searchable do
            @searchable ||= associated_model_config.abstract_model.properties.collect(&:name).include?(associated_model_config.object_label_method) ? [associated_model_config.object_label_method, {abstract_model.model => method_name}] : {abstract_model.model => method_name}
          end

          register_instance_option :eager_load do
            true
          end

          register_instance_option :allowed_methods do
            nested_form ? [method_name] : Array(association.foreign_key)
          end

          def selected_id
            if association.foreign_key.is_a?(Array)
              format_key(association.foreign_key.map { |attribute| bindings[:object].safe_send(attribute) })
            else
              bindings[:object].safe_send(association.key_accessor)
            end
          end

          def parse_input(params)
            return super if nested_form
            return unless params[method_name].present? && association.foreign_key.is_a?(Array)

            association.foreign_key.zip(RailsAdmin.config.composite_keys_serializer.deserialize(params.delete(method_name))).each do |key, value|
              params[key] = value
            end
          end
        end
      end
    end
  end
end
