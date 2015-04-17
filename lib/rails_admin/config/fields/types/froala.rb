require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Froala < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          # If you want to have a different toolbar configuration for wysihtml5
          # you can use a Ruby hash to configure these options:
          # https://github.com/jhollingworth/bootstrap-wysihtml5/#advanced
          register_instance_option :config_options do
            nil
          end

          register_instance_option :css_location do
            ActionController::Base.helpers.asset_path('froala_editor.min.css')
          end

          register_instance_option :js_location do
            ActionController::Base.helpers.asset_path('froala_editor.min.js')
          end

          register_instance_option :partial do
            :form_froala
          end

          [:config_options, :css_location, :js_location].each do |key|
            register_deprecated_instance_option :"froala_#{key}", key
          end
        end
      end
    end
  end
end
