# frozen_string_literal: true

require 'rails_admin/config/fields/types/text'
require 'rails_admin/version'

module RailsAdmin
  module Config
    module Fields
      module Types
        class CodeMirror < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          deprecated 'CodeMirror 5 is no longer maintained, and CodeMirror 6 is not a drop-in replacement'

          # Pass the theme and mode for Codemirror
          register_instance_option :config do
            {
              mode: 'css',
              theme: 'night',
            }
          end

          register_instance_option :version do
            RailsAdmin::Version.npm_dependency('codemirror')
          end

          # Pass the location of the theme and mode for Codemirror
          # The npm package ships no minified build, so these are the sources.
          register_instance_option :assets do
            {
              mode: "https://unpkg.com/codemirror@#{version}/mode/css/css.js",
              theme: "https://unpkg.com/codemirror@#{version}/theme/night.css",
            }
          end

          register_instance_option :js_location do
            "https://unpkg.com/codemirror@#{version}/lib/codemirror.js"
          end

          register_instance_option :css_location do
            "https://unpkg.com/codemirror@#{version}/lib/codemirror.css"
          end

          register_instance_option :partial do
            :form_code_mirror
          end
        end
      end
    end
  end
end
