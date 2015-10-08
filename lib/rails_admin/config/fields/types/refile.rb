require 'rails_admin/config/fields/base'
require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Refile < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :thumb_method do
            [:limit, 100, 100]
          end

          register_instance_option :delete_method do
            "remove_#{name}"
          end

          def resource_url(thumb = [])
            return nil unless value
            Object.const_get(:Refile).attachment_url(bindings[:object], name, *thumb)
          end
        end
      end
    end
  end
end
