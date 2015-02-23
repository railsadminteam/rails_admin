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

          def parse_input(params)
            return unless params[name].is_a?(::String)
            params[name] = (params[name].blank? ? nil : JSON.parse(params[name]))
          end
        end
      end
    end
  end
end
