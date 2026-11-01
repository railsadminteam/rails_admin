# frozen_string_literal: true

require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Froala < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          deprecated 'Froala is a commercial editor, and CVE-2024-51434 has no fixed release'

          # See https://www.froala.com/wysiwyg-editor/docs/options
          register_instance_option :config_options do
            nil
          end

          # There is no default location: Froala is licensed per application, and the
          # release RailsAdmin used to name is affected by an unfixed advisory.
          register_instance_option :css_location do
            nil
          end

          register_instance_option :js_location do
            nil
          end

          register_instance_option :partial do
            :form_froala
          end
        end
      end
    end
  end
end
