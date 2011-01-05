require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Integer < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:css_class) do
            serial? ? "id" : "integer"
          end

          register_instance_option(:column_width) do
            serial? ? 46 : 80
          end
        end
      end
    end
  end
end