require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class String < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @searchable = true

          register_instance_option(:help) do
            text = required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")
            text += " #{length} "
            text += length == 1 ? I18n.translate("admin.new.one_char") : I18n.translate("admin.new.many_chars")
            text
          end

          register_instance_option(:color) do
            false
          end
        end
      end
    end
  end
end
