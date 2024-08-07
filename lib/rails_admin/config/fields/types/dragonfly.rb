# frozen_string_literal: true

require 'rails_admin/config/fields/base'
require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        # Field type that supports Paperclip file uploads
        class Dragonfly < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :image? do
            if abstract_model.model.new.respond_to?("#{name}_name")
              mime_type = Mime::Type.lookup_by_extension(bindings[:object].send("#{name}_name").to_s.split('.').last)
              mime_type.to_s.match?(/^image/)
            else
              true # Dragonfly really is image oriented
            end
          end

          register_instance_option :delete_method do
            "remove_#{name}"
          end

          register_instance_option :cache_method do
            "retained_#{name}"
          end

          register_instance_option :thumb_method do
            '100x100>'
          end

          def resource_url(thumb = false)
            return nil unless (v = value)

            thumb ? v.thumb(thumb).try(:url) : v.url
          end
        end
      end
    end
  end
end
