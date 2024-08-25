# frozen_string_literal: true

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

            register_instance_option :keep_value do
              value.signed_id
            end

            register_instance_option :delete_value do
              value.id
            end

            register_instance_option :image? do
              value && (value.representable? || mime_type(value.filename).to_s.match?(/^image/))
            end

            def resource_url(thumb = false)
              return nil unless value

              if thumb && value.representable?
                repr = value.representation(thumb_method)
                Rails.application.routes.url_helpers.rails_blob_representation_path(
                  repr.blob.signed_id, repr.variation.key, repr.blob.filename, only_path: true
                )
              else
                Rails.application.routes.url_helpers.rails_blob_path(value, only_path: true)
              end
            end

            def mime_type(filename_obj)
              Mime::Type.lookup_by_extension(filename_obj.extension_without_delimiter)
            end
          end

          register_instance_option :attachment_class do
            ActiveStorageAttachment
          end

          register_instance_option :keep_method do
            method_name if ::ActiveStorage.gem_version >= Gem::Version.new('7.1') || ::ActiveStorage.replace_on_assign_to_many
          end

          register_instance_option :delete_method do
            "remove_#{name}" if bindings[:object].respond_to?("remove_#{name}")
          end

          register_instance_option :eager_load do
            {"#{name}_attachments": :blob}
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
        end
      end
    end
  end
end
