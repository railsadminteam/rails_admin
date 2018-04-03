module RailsAdmin
  module Config
    module Fields
      module Types
        class ActiveStorage < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :thumb_method do
            { resize: '300x200>' }
          end

          register_instance_option :delete_method do
            "remove_#{name}" if bindings[:object].respond_to?("remove_#{name}")
          end

          register_instance_option :presence_method do
            # `attachment` returns Attachment instance or `nil` if not attached
            :attachment
          end

          register_instance_option :image? do
            if value.attached?
              value.filename.to_s.split('.').last =~ /jpg|jpeg|png|gif|svg/i
            end
          end

          def resource_url(thumb = false)
            return nil unless value.attached?
            v = bindings[:view]
            if thumb && value.variable?
              variant = value.variant(thumb)
              Rails.application.routes.url_helpers.rails_blob_representation_path(
                variant.blob.signed_id, variant.variation.key, variant.blob.filename, only_path: true
              )
            else
              Rails.application.routes.url_helpers.rails_blob_path(value, only_path: true)
            end
          end
        end
      end
    end
  end
end
