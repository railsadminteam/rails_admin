require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Json < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option :html_attributes do
            {
                :cols => '48',
                :rows => '3'
            }
          end

          register_instance_option :partial do
            :form_text
          end

          register_instance_option :formatted_value do
            value.present? ? value.to_json : nil
          end

          def parse_input(params)
            if params[name].is_a?(::String)
              params[name] = (params[name].blank? ? nil : JSON.parse(params[name]) )
            end
          end

        end
      end
    end
  end
end
