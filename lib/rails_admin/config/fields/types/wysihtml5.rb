

require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Wysihtml5 < Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

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

          register_instance_option :css_location do
            "https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-wysiwyg/#{version}/bootstrap3-wysihtml5.min.css"
          end

          register_instance_option :js_location do
            "https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-wysiwyg/#{version}/bootstrap3-wysihtml5.all.min.js"
          end

          register_instance_option :partial do
            :form_wysihtml5
          end
        end
      end
    end
  end
end
