require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class CodeMirror < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          # Pass the theme and mode for Codemirror
          register_instance_option :config do
            {
              mode: 'css',
              theme: 'night',
            }
          end

          # Pass the location of the theme and mode for Codemirror
          register_instance_option :assets do
            {
              mode: ::ActionController::Base.helpers.asset_path('codemirror/modes/css.js'),
              theme: ::ActionController::Base.helpers.asset_path('codemirror/themes/night.css'),
            }
          end

          # Use this if you want to point to a cloud instances of CodeMirror
          register_instance_option :js_location do
            ::ActionController::Base.helpers.asset_path('codemirror.js')
          end

          # Use this if you want to point to a cloud instances of CodeMirror
          register_instance_option :css_location do
            ::ActionController::Base.helpers.asset_path('codemirror.css')
          end

          register_instance_option :partial do
            :form_code_mirror
          end

          [:assets, :config, :css_location, :js_location].each do |key|
            register_deprecated_instance_option :"codemirror_#{key}", key
          end
        end
      end
    end
  end
end
