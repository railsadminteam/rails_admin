# frozen_string_literal: true

require 'rails_admin/config/fields/singular_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BelongsToAssociation < RailsAdmin::Config::Fields::SingularAssociation
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :sortable do
            # Sort by whatever labels the associated record, when that is an
            # attribute the store knows about. Reaching it may take a join or may
            # not be possible at all, but that is the adapter's problem now.
            @sortable ||= label_attribute || sortable_foreign_key
          end

          register_instance_option :searchable do
            @searchable ||= [label_attribute, *foreign_keys.collect { |key| {abstract_model.model => key} }].compact
          end

          register_instance_option :eager_load do
            true
          end

          register_instance_option :allowed_methods do
            nested_form ? [method_name] : foreign_keys
          end

          def selected_id
            if association.foreign_key.is_a?(Array)
              format_key(association.foreign_key.map { |attribute| abstract_model.read(bindings[:object], attribute) })
            else
              abstract_model.read(bindings[:object], association.key_accessor)
            end
          end

          def parse_input(params)
            return super if nested_form
            return unless params[method_name].present? && association.foreign_key.is_a?(Array)

            keys = associated_model_config.abstract_model.parse_id(params.delete(method_name))
            association.foreign_key.zip(keys).each do |key, value|
              params[key] = value
            end
          end

        private

          # What labels the associated record, when the store knows it as an
          # attribute rather than the model as a method.
          def label_attribute
            label = associated_model_config.object_label_method
            label if associated_model_config.abstract_model.properties.any? { |property| property.name == label }
          end

          # The columns the association is stored in, always as an array.
          def foreign_keys
            Array(association.foreign_key)
          end

          # A sort is one column, so a composite key cannot stand in for the
          # label and the field is left unsortable.
          def sortable_foreign_key
            foreign_keys.one? && {abstract_model.table_name => foreign_keys.first}
          end
        end
      end
    end
  end
end
