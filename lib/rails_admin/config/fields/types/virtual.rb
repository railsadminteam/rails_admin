require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        # Virtual field class provides behaviour for columns that are
        # calculated at runtime for example record object methods.
        class Virtual < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          # Accessor for field's maximum length.
          register_instance_option(:length) do
            100
          end

          # Reader for whether this is field is mandatory.
          register_instance_option(:required?) do
            false
          end

          # Reader for whether this is a serial field (aka. primary key, identifier).
          register_instance_option(:serial?) do
            false
          end

          register_instance_option(:sortable) do
            false
          end

          register_instance_option(:searchable) do
            false
          end
        end
      end
    end
  end
end
