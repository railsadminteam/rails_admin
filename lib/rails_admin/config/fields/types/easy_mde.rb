# frozen_string_literal: true

require 'rails_admin/config/fields/types/text'
require 'rails_admin/version'

module RailsAdmin
  module Config
    module Fields
      module Types
        class EasyMDE < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          # EasyMDE is the maintained fork of SimpleMDE, which this field type used to load.
          RailsAdmin::Config::Fields::Types.register(:simple_mde, self)

          # If you want to have a different EasyMDE config for each instance
          # you can override this option with these values: https://github.com/Ionaru/easy-markdown-editor#configuration
          register_instance_option :instance_config do
            nil
          end

          register_instance_option :version do
            RailsAdmin::Version.npm_dependency('easymde')
          end

          register_instance_option :js_location do
            "https://unpkg.com/easymde@#{version}/dist/easymde.min.js"
          end

          register_instance_option :css_location do
            "https://unpkg.com/easymde@#{version}/dist/easymde.min.css"
          end

          register_instance_option :partial do
            :form_easy_mde
          end
        end
      end
    end
  end
end
