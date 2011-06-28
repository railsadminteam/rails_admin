require 'rails_admin/config/fields'
require 'rails_admin/config/sections/list'
require 'rails_admin/config/fields/types/virtual'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Tsvector < RailsAdmin::Config::Fields::Types::Virtual
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          def initialize(parent, name, properties)
            super(parent, name, properties)
            # We should not show it
            hide
          end

          register_instance_option(:formatted_value) do
            "".html_safe
          end

          # Tsvector field's value does not need to be read
          def value
            ""
          end
        end
      end
    end
  end
end