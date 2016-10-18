require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class FileUpload < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :partial do
            :form_file_upload
          end

          register_instance_option :thumb_method do
            nil
          end

          register_instance_option :delete_method do
            nil
          end

          register_instance_option :cache_method do
            nil
          end

          register_instance_option :export_value do
            resource_url.to_s
          end

          register_instance_option :pretty_value do
            if value.presence
              v = bindings[:view]
              url = resource_url
              if image
                thumb_url = resource_url(thumb_method)
                image_html = v.image_tag(thumb_url, class: 'img-thumbnail')
                url != thumb_url ? v.link_to(image_html, url, target: '_blank') : image_html
              else
                v.link_to(nil, url, target: '_blank')
              end
            end
          end

          register_instance_option :image? do
            (url = resource_url.to_s) && url.split('.').last =~ /jpg|jpeg|png|gif|svg/i
          end

          register_instance_option :allowed_methods do
            [method_name, delete_method, cache_method].compact
          end

          register_instance_option :html_attributes do
            {
              required: required? && !value.present?,
            }
          end

          # virtual class
          def resource_url
            raise('not implemented')
          end

          def virtual?
            true
          end
        end
      end
    end
  end
end
