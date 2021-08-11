require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Decimal < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :view_helper do
            :number_field
          end

          register_instance_option :html_attributes do
            {
              required: required?,
              step: "any",
            }
          end
        end
      end
    end
  end
end
