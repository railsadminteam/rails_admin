require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Text < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @view_helper = :text_area

          # CKEditor is disabled by default
          register_instance_option(:ckeditor) do
            false
          end

          # If you want to have a different toolbar configuration for CKEditor
          # create your own custom config.js and override this configuration
          register_instance_option(:ckeditor_config_js) do
            "/javascripts/ckeditor/config.js"
          end
          
          register_instance_option(:pretty_value) do
            bindings[:view].truncate(formatted_value.to_s, :length => 60)
          end

          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil}",
              :cols => 80,
              :style => "width:#{column_width}px",
              :value => value,
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
