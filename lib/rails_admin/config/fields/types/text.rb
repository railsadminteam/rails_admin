require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Text < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          [:ckeditor, :ckeditor_base_location, :ckeditor_config_js, :ckeditor_location].each do |key|
            register_deprecated_instance_option key do
              fail("The 'field(:foo){ ckeditor true }' style DSL is deprecated. Please use 'field :foo, :ck_editor' instead.")
            end
          end

          [:codemirror, :codemirror_assets, :codemirror_config, :codemirror_css_location, :codemirror_js_location].each do |key|
            register_deprecated_instance_option key do
              fail("The 'field(:foo){ codemirror true }' style DSL is deprecated. Please use 'field :foo, :code_mirror' instead.")
            end
          end

          [:bootstrap_wysihtml5, :bootstrap_wysihtml5_config_options, :bootstrap_wysihtml5_css_location, :bootstrap_wysihtml5_js_location].each do |key|
            register_deprecated_instance_option key do
              fail("The 'field(:foo){ bootstrap_wysihtml5 true }' style DSL is deprecated. Please use 'field :foo, :wysihtml5' instead.")
            end
          end

          register_instance_option :html_attributes do
            {
              cols: '48',
              rows: '3',
            }
          end

          register_instance_option :partial do
            :form_text
          end
        end
      end
    end
  end
end
