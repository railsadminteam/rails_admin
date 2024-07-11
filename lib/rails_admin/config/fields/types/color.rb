

require 'rails_admin/config/fields/types/string_like'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Color < StringLike
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :pretty_value do
            bindings[:view].content_tag :strong, (value.presence || ' - '), style: "color: #{color}"
          end

          register_instance_option :partial do
            :form_colorpicker
          end

          register_instance_option :view_helper do
            :color_field
          end

          register_instance_option :color do
            if value.present?
              if /^[0-9a-fA-F]{3,6}$/.match?(value)
                "##{value}"
              else
                value
              end
            else
              'white'
            end
          end

          register_instance_option :export_value do
            formatted_value
          end
        end
      end
    end
  end
end
