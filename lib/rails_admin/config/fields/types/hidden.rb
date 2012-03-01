require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Hidden < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types::register(self)

          @view_helper = :hidden_field

          register_instance_option(:partial) do
            :form_field
          end
        end
      end
    end
  end
end
