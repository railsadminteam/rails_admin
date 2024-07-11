

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
                next nil unless bindings[:object].respond_to?("#{name}_derivatives")

                derivatives = bindings[:object].public_send("#{name}_derivatives")

                if derivatives.key?(:thumb)
                  :thumb
                elsif derivatives.key?(:thumbnail)
                  :thumbnail
                else
                  derivatives.keys.first
                end
              end
            end
            @thumb_method
          end

          register_instance_option :delete_method do
            "remove_#{name}" if bindings[:object].respond_to?("remove_#{name}")
          end

          register_instance_option :cache_method do
            name if bindings[:object].try("cached_#{name}_data")
          end

          register_instance_option :cache_value do
            bindings[:object].try("cached_#{name}_data")
          end

          register_instance_option :link_name do
            value.original_filename
          end

          def resource_url(thumb = nil)
            return nil unless value

            thumb && bindings[:object].public_send(:"#{name}", thumb).try(:url) || value.url
          end
        end
      end
    end
  end
end
