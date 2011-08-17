require 'rails_admin/config/fields'
require 'rails_admin/config/sections/list'
require 'rails_admin/config/fields/types/virtual'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Password < RailsAdmin::Config::Fields::Types::Virtual
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @column_names = [:password]
          @view_helper = :password_field

          def self.column_names
            @column_names
          end

          def initialize(parent, name, properties)
            super(parent, name, properties)
            hide if parent.kind_of?(RailsAdmin::Config::Sections::List)
          end

          register_instance_option(:formatted_value) do
            "".html_safe
          end

          # Password field's value does not need to be read
          def value
            ""
          end

          register_instance_option(:pretty_value) do
            '*****'
          end
        end
      end
    end
  end
end
