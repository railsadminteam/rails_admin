require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class SimpleMDE < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          # If you want to have a different SimpleMDE config for each instance
          # you can override this option with these values: https://github.com/sparksuite/simplemde-markdown-editor#configuration
          register_instance_option :instance_config do
            nil
          end

          # Use this if you want to point to a cloud instance of the base SimpleMDE
          register_instance_option :js_location do
            "#{Rails.application.config.assets.prefix}/simplemde.min.js"
          end

          register_instance_option :css_location do
            "#{Rails.application.config.assets.prefix}/simplemde.min.css"
          end

          register_instance_option :partial do
            :form_simple_mde
          end
        end
      end
    end
  end
end
