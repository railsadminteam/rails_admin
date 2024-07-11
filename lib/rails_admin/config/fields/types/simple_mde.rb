

require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class SimpleMDE < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          # If you want to have a different SimpleMDE config for each instance
          # you can override this option with these values: https://github.com/sparksuite/simplemde-markdown-editor#configuration
          register_instance_option :instance_config do
            nil
          end

          register_instance_option :version do
            '1.11.2'
          end

          register_instance_option :js_location do
            "https://cdnjs.cloudflare.com/ajax/libs/simplemde/#{version}/simplemde.min.js"
          end

          register_instance_option :css_location do
            "https://cdnjs.cloudflare.com/ajax/libs/simplemde/#{version}/simplemde.min.css"
          end

          register_instance_option :partial do
            :form_simple_mde
          end
        end
      end
    end
  end
end
