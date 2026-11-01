# frozen_string_literal: true

require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class CKEditor < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          deprecated 'CKEditor 4 is end-of-life, and no freely licensed release of it is free of known vulnerabilities'

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
          # There is no default: every release RailsAdmin could name is either vulnerable
          # or licensed so that it cannot be picked on the application's behalf.
          register_instance_option :base_location do
            nil
          end

          register_instance_option :partial do
            :form_ck_editor
          end
        end
      end
    end
  end
end
