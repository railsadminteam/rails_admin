require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Shrine < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :thumb_method do
            unless defined? @thumb_method
              @thumb_method = begin
                next nil unless value.is_a?(Hash)

                if value.key?(:thumb)
                  :thumb
                elsif value.key?(:thumbnail)
                  :thumbnail
                else
                  value.keys.first
                end
              end
            end
            @thumb_method
          end

          register_instance_option :delete_method do
            "remove_#{name}" if bindings[:object].respond_to?("remove_#{name}")
          end

          register_instance_option :cache_method do
            name
          end

          register_instance_option :cache_value do
            bindings[:object].public_send("cached_#{name}_data") if bindings[:object].respond_to?("cached_#{name}_data")
          end

          def resource_url(thumb = nil)
            return nil unless value

            if value.is_a?(Hash)
              value[thumb || value.keys.first].url
            else
              value.url
            end
          end
        end
      end
    end
  end
end
