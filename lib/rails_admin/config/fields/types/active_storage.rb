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
            value && (value.representable? || value.content_type.match?(/^image/))
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

          register_instance_option :searchable do
            false
          end

          register_instance_option :sortable do
            false
          end

          def resource_url(thumb = false)
            return nil unless value

            if thumb && value.representable?
              thumb = thumb_method if thumb == true
              representation = value.representation(thumb)
              Rails.application.routes.url_helpers.rails_blob_representation_path(
                representation.blob.signed_id, representation.variation.key, representation.blob.filename, only_path: true
              )
            else
              Rails.application.routes.url_helpers.rails_blob_path(value, only_path: true)
            end
          end

          def value
            attachment = super
            attachment if attachment&.attached?
          end
        end
      end
    end
  end
end
