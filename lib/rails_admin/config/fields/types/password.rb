require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Password < RailsAdmin::Config::Fields::Types::String
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option :view_helper do
            :password_field
          end

          def parse_input(params)
            params[name] = params[name].presence
          end

          register_instance_option :formatted_value do
            "".html_safe
          end

          # Password field's value does not need to be read
          def value
            ""
          end

          register_instance_option :visible do
            self.section.is_a?(RailsAdmin::Config::Sections::Edit)
          end

          register_instance_option :pretty_value do
            '*****'
          end
        end
      end
    end
  end
end
