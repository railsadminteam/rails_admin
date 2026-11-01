# frozen_string_literal: true

require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Wysihtml5 < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          deprecated 'bootstrap3-wysihtml5 has had no release since 2014'

          # If you want to have a different toolbar configuration for wysihtml5
          # you can use a Ruby hash to configure these options:
          # https://github.com/bootstrap-wysiwyg/bootstrap3-wysiwyg
          register_instance_option :config_options do
            {
              toolbar: {
                fa: true,
              },
            }
          end

          register_instance_option :version do
            '0.3.3'
          end

          # 0.3.3 is the last release there is, so the version is not tracked in package.json.
          register_instance_option :css_location do
            "https://unpkg.com/bootstrap3-wysihtml5-bower@#{version}/dist/bootstrap3-wysihtml5.min.css"
          end

          register_instance_option :js_location do
            "https://unpkg.com/bootstrap3-wysihtml5-bower@#{version}/dist/bootstrap3-wysihtml5.all.min.js"
          end

          register_instance_option :partial do
            :form_wysihtml5
          end
        end
      end
    end
  end
end
