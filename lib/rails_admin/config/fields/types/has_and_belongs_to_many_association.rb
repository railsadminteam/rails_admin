require 'rails_admin/config/fields/types/has_many_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasAndBelongsToManyAssociation < RailsAdmin::Config::Fields::Types::HasManyAssociation
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :multiple do
            bindings[:object].respond_to?(:multiple) ? bindings[:object].send(:multiple) : false
          end

          def parse_value(value)
            value
          end

        end
      end
    end
  end
end
