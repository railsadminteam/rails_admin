require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class CodeMirror < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          # Pass the theme and mode for Codemirror
          register_instance_option :config do
            {
              mode: 'css',
              theme: 'night',
            }
          end

          register_instance_option :version do
            '5.46.0'
          end

          # Pass the location of the theme and mode for Codemirror
          register_instance_option :assets do
            {
              mode: "https://cdnjs.cloudflare.com/ajax/libs/codemirror/#{version}/mode/css/css.min.js",
              theme: "https://cdnjs.cloudflare.com/ajax/libs/codemirror/#{version}/theme/night.min.css",
            }
          end

          register_instance_option :js_location do
            "https://cdnjs.cloudflare.com/ajax/libs/codemirror/#{version}/codemirror.min.js"
          end

          register_instance_option :css_location do
            "https://cdnjs.cloudflare.com/ajax/libs/codemirror/#{version}/codemirror.min.css"
          end

          register_instance_option :partial do
            :form_code_mirror
          end
        end
      end
    end
  end
end
