require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Integer < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @view_helper = :number_field

          register_instance_option(:sort_reverse?) do
            serial?
          end
        end
      end
    end
  end
end
