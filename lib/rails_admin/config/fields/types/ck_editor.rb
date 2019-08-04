require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class CKEditor < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :version do
            '4.11.4'
          end

          # If you want to have a different toolbar configuration for CKEditor
          # create your own custom config.js and override this configuration
          register_instance_option :config_js do
            nil
          end

          # Use this if you want to point to a cloud instances of CKeditor
          register_instance_option :location do
            nil
          end

          # Use this if you want to point to a cloud instances of the base CKeditor
          register_instance_option :base_location do
            "https://cdnjs.cloudflare.com/ajax/libs/ckeditor/#{version}/"
          end

          register_instance_option :partial do
            :form_ck_editor
          end
        end
      end
    end
  end
end
