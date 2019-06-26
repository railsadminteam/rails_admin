require 'rails_admin/config/fields/base'
require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Color < RailsAdmin::Config::Fields::Types::String
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :html_attributes do
            {
              required: required?,
            }
          end

          register_instance_option :pretty_value do
            bindings[:view].content_tag :strong, (value.presence || ' - '), style: "color: #{color}"
          end

          register_instance_option :partial do
            :form_colorpicker
          end

          register_instance_option :color do
            if value.present?
              if value =~ /^[0-9a-fA-F]{3,6}$/
                '#' + value
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
