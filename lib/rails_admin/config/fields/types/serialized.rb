require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Serialized < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :formatted_value do
            RailsAdmin.yaml_dump(value) unless value.nil?
          end

          def parse_value(value)
            value.present? ? (RailsAdmin.yaml_load(value.try(:to_s)) || nil) : nil
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name].is_a?(::String)
          end
        end
      end
    end
  end
end
