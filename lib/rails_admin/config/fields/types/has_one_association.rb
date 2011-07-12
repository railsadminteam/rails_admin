require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasOneAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:edit_partial) do
            :form_filtering_select
          end

          # Accessor for whether this is field is required.  In this
          # case the field is "virtual" to this table - it actually
          # lives in the table on the "belongs_to" side of this
          # relation.
          #
          # @see RailsAdmin::AbstractModel.properties
          register_instance_option(:required?) do
            false
          end

          def selected_id
            (object = value).nil? ? nil : object.id
          end

          def method_name
            super.singularize + '_id'
          end
        end
      end
    end
  end
end
