

require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Froala < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          # See https://www.froala.com/wysiwyg-editor/docs/options
          register_instance_option :config_options do
            nil
          end

          register_instance_option :version do
            '2.9.5'
          end

          register_instance_option :css_location do
            "https://cdnjs.cloudflare.com/ajax/libs/froala-editor/#{version}/css/froala_editor.min.css"
          end

          register_instance_option :js_location do
            "https://cdnjs.cloudflare.com/ajax/libs/froala-editor/#{version}/js/froala_editor.min.js"
          end

          register_instance_option :partial do
            :form_froala
          end
        end
      end
    end
  end
end
