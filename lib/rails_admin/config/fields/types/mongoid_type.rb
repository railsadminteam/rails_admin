require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class MongoidType < RailsAdmin::Config::Fields::Types::String
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:label) do
            "Type"
          end

          register_instance_option(:visible) do
            false
          end
        end
      end
    end
  end
end



