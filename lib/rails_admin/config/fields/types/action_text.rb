# frozen_string_literal: true

require 'rails_admin/config/fields/types/text'
require 'rails_admin/version'

module RailsAdmin
  module Config
    module Fields
      module Types
        class ActionText < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :version do
            RailsAdmin::Version.npm_dependency('trix')
          end

          register_instance_option :css_location do
            "https://unpkg.com/trix@#{version}/dist/trix.css"
          end

          register_instance_option :js_location do
            # Trix 2 dropped dist/trix.js, and $.getScript can only load the UMD build.
            file = version.to_s.start_with?('1.') ? 'trix.js' : 'trix.umd.min.js'
            "https://unpkg.com/trix@#{version}/dist/#{file}"
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
