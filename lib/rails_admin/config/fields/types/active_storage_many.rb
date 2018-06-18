require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class ActiveStorageMany < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :partial do
            :form_active_storage_many
          end

          register_instance_option :thumb_method do
            { resize: '100x100>' }
          end

          register_instance_option :delete_method do
            "remove_#{name}"
          end

          register_instance_option :cache_method do
            nil
          end

          register_instance_option :presence_method do
            :presence
          end

          register_instance_option :export_value do
            resource_url.to_s
          end

          register_instance_option :pretty_value do
            attachments = value.send(presence_method)
            if attachments
              v = bindings[:view]
              attachments.map do |attachment|
                format_html(attachment, v)
              end.join('').html_safe
            end
          end

          register_instance_option :allowed_methods do
            [method_name, delete_method, cache_method].compact
          end

          register_instance_option :html_attributes do
            {
              required: required? && !value.present?,
            }
          end

          def image?(attachment)
            attachment.filename.to_s.split('.').last =~ /jpg|jpeg|png|gif|svg/i
          end

          def format_html(attachment, v = bindings[:view])
            url = resource_url(attachment)
            if image?(attachment)
              thumb_url = resource_url(attachment, thumb_method)
              image_html = v.image_tag(thumb_url, class: 'img-thumbnail')
              url != thumb_url ? v.link_to(image_html, url, target: '_blank') : image_html
            else
              v.link_to(nil, url, target: '_blank')
            end
          end

          # virtual class
          def resource_url(attachment, thumb = false)
            return nil unless attachment
            v = bindings[:view]
            if thumb && attachment.variable?
              variant = attachment.variant(thumb)
              Rails.application.routes.url_helpers.rails_blob_representation_path(
                variant.blob.signed_id, variant.variation.key, variant.blob.filename, only_path: true
              )
            else
              Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
            end
          end

          def virtual?
            true
          end
        end
      end
    end
  end
end
