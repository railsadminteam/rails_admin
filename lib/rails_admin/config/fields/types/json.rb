require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Json < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)
          RailsAdmin::Config::Fields::Types.register(:jsonb, self)

          register_instance_option :formatted_value do
            value.present? ? JSON.pretty_generate(value) : nil
          end

          def parse_value(value)
            value.present? ? JSON.parse(value) : nil
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name].is_a?(::String)
          end
        end
      end
    end
  end
end
