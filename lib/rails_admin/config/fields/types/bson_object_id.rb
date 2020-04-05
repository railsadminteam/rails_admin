require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BsonObjectId < RailsAdmin::Config::Fields::Types::String
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :label do
            label = ((@label ||= {})[::I18n.locale] ||= abstract_model.model.human_attribute_name name)
            label = 'Id' if label == ''
            label
          end

          def generic_help
            'BSON::ObjectId'
          end

          register_instance_option :read_only do
            true
          end

          register_instance_option :sort_reverse? do
            serial?
          end

          def parse_value(value)
            value.present? ? abstract_model.parse_object_id(value) : nil
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name].is_a?(::String)
          end
        end
      end
    end
  end
end
