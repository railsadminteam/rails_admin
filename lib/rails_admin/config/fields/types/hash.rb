require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Hash < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @view_helper = :text_area

          register_instance_option(:html_default_value) do
            YAML.dump(value)
          end
        end
      end
    end
  end
end



