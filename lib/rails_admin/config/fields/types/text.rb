

require 'rails_admin/config/fields/types/string_like'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Text < StringLike
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :html_attributes do
            {
              required: required?,
              cols: '48',
              rows: '3',
            }
          end

          register_instance_option :partial do
            :form_text
          end
        end
      end
    end
  end
end
