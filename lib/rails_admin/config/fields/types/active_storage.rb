# frozen_string_literal: true

require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        class ActiveStorage < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :thumb_method do
            {resize_to_limit: [100, 100]}
          end

          register_instance_option :delete_method do
            "remove_#{name}" if bindings[:object].respond_to?("remove_#{name}")
          end

          register_instance_option :image? do
            if value
              value.representable? || mime_type(value.filename).to_s.match?(/^image/)
            end
          end

          register_instance_option :eager_load do
            {"#{name}_attachment": :blob}
          end

          register_instance_option :direct? do
            false
          end

          register_instance_option :html_attributes do
            {
              required: required? && !value.present?,
            }.merge(
              direct? && {data: {direct_upload_url: bindings[:view].main_app.rails_direct_uploads_url}} || {},
            )
          end

          def resource_url(thumb = false)
            return nil unless value

            if thumb && value.representable?
              thumb = thumb_method if thumb == true
              repr = value.representation(thumb)
              Rails.application.routes.url_helpers.rails_blob_representation_path(
                repr.blob.signed_id, repr.variation.key, repr.blob.filename, only_path: true
              )
            else
              Rails.application.routes.url_helpers.rails_blob_path(value, only_path: true)
            end
          end

          def value
            attachment = super
            attachment if attachment&.attached?
          end

          def mime_type(filename_obj)
            Mime::Type.lookup_by_extension(filename_obj.extension_without_delimiter)
          end
        end
      end
    end
  end
end
