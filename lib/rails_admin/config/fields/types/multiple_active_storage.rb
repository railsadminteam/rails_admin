require 'rails_admin/config/fields/types/multiple_file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        class MultipleActiveStorage < RailsAdmin::Config::Fields::Types::MultipleFileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          class ActiveStorageAttachment < RailsAdmin::Config::Fields::Types::MultipleFileUpload::AbstractAttachment
            register_instance_option :thumb_method do
              {resize_to_limit: [100, 100]}
            end

            register_instance_option :delete_value do
              value.id
            end

            register_instance_option :image? do
              if value
                mime_type = Mime::Type.lookup_by_extension(value.filename.extension_without_delimiter)
                mime_type.to_s.match?(/^image/)
              end
            end

            def resource_url(thumb = false)
              return nil unless value

              if thumb && value.variable?
                variant = value.variant(thumb_method)
                Rails.application.routes.url_helpers.rails_blob_representation_path(
                  variant.blob.signed_id, variant.variation.key, variant.blob.filename, only_path: true
                )
              else
                Rails.application.routes.url_helpers.rails_blob_path(value, only_path: true)
              end
            end
          end

          register_instance_option :attachment_class do
            ActiveStorageAttachment
          end

          register_instance_option :delete_method do
            "remove_#{name}" if bindings[:object].respond_to?("remove_#{name}")
          end

          register_instance_option :eager_load do
            {"#{name}_attachments": :blob}
          end
        end
      end
    end
  end
end
