

require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class ActionText < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :version do
            '1.3.1'
          end

          register_instance_option :css_location do
            "https://cdnjs.cloudflare.com/ajax/libs/trix/#{version}/trix.css"
          end

          register_instance_option :js_location do
            "https://cdnjs.cloudflare.com/ajax/libs/trix/#{version}/trix.js"
          end

          register_instance_option :warn_dynamic_load do
            true
          end

          register_instance_option :partial do
            :form_action_text
          end
        end
      end
    end
  end
end
