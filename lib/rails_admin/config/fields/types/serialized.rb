require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Serialized < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          
          register_instance_option :formatted_value do
            YAML.dump value
          end
          
          def parse_input(params)
            params[name] = (params[name].blank? ? nil : YAML.load(params[name])) if params[name].is_a?(::String)
          end
        end
      end
    end
  end
end
