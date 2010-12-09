require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasManyAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          # Accessor for field's help text displayed below input field.
          register_instance_option(:help) do
            ""
          end
        end
      end
    end
  end
end