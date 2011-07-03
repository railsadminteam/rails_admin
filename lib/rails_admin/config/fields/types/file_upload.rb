require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class FileUpload < RailsAdmin::Config::Fields::Types::String

          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:help) do
            (required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional") + '. ')
          end
        end
      end
    end
  end
end