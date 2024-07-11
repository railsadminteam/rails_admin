

require 'rails_admin/config/fields/base'
require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        # Field type that supports Paperclip file uploads
        class Paperclip < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :delete_method do
            "delete_#{name}" if bindings[:object].respond_to?("delete_#{name}")
          end

          register_instance_option :thumb_method do
            @styles ||= bindings[:object].send(name).styles.collect(&:first)
            @thumb_method ||= @styles.detect { |s| [:thumb, 'thumb', :thumbnail, 'thumbnail'].include?(s) } || @styles.first || :original
          end

          def resource_url(thumb = false)
            value.try(:url, (thumb || :original))
          end
        end
      end
    end
  end
end
