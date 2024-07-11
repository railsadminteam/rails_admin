

require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Numeric < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :filter_operators do
            %w[default between] + (required? ? [] : %w[_separator _not_null _null])
          end

          register_instance_option :view_helper do
            :number_field
          end
        end
      end
    end
  end
end
