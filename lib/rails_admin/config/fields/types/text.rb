require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Text < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          
          # CKEditor is disabled by default
          register_instance_option(:ckeditor) do
            false
          end

          # If you want to have a different toolbar configuration for CKEditor
          # create your own custom config.js and override this configuration
          register_instance_option(:ckeditor_config_js) do
            "/assets/ckeditor/config.js"
          end

          #Use this if you want to point to a cloud instances of CKeditor
          register_instance_option(:ckeditor_location) do
            '/assets/ckeditor/ckeditor.js'
          end

          #Use this if you want to point to a cloud instances of the base CKeditor
          register_instance_option(:ckeditor_base_location) do
            '/assets/ckeditor/'
          end

          # Codemirror is disabled by default and CKEditor takes precedence
          register_instance_option(:codemirror) do
            false
          end

          #Pass the theme and mode for Codemirror
          register_instance_option(:codemirror_config) do
            {
              :mode => 'css',
              :theme => 'night'
            }
          end

          #Pass the location of the theme and mode for Codemirror
          register_instance_option(:codemirror_assets) do
            {
              :mode => '/assets/codemirror/modes/css.js',  
              :theme => '/assets/codemirror/themes/night.css'
            }
          end

          #Use this if you want to point to a cloud instances of CodeMirror
          register_instance_option(:codemirror_js_location) do
            '/assets/codemirror.js'
          end

          #Use this if you want to point to a cloud instances of CodeMirror
          register_instance_option(:codemirror_css_location) do
            '/assets/codemirror.css'
          end

          register_instance_option(:html_attributes) do
            {
              :cols => "48",
              :rows => "3"
            }
          end

          register_instance_option(:partial) do
            :form_text
          end
        end
      end
    end
  end
end
