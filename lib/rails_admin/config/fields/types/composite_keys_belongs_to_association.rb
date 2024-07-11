

require 'rails_admin/config/fields/types/belongs_to_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class CompositeKeysBelongsToAssociation < RailsAdmin::Config::Fields::Types::BelongsToAssociation
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :allowed_methods do
            nested_form ? [method_name] : Array(association.foreign_key)
          end

          def selected_id
            association.foreign_key.map { |attribute| bindings[:object].safe_send(attribute) }.to_composite_keys.to_s
          end

          def parse_input(params)
            return unless params[method_name].present? && association.foreign_key.is_a?(Array) && !nested_form

            association.foreign_key.zip(CompositePrimaryKeys::CompositeKeys.parse(params.delete(method_name))).each do |key, value|
              params[key] = value
            end
          end
        end
      end
    end
  end
end
