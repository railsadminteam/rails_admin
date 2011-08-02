require 'rails_admin/config/fields/base'
require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin::Config::Fields::Types
    # Field type that supports CarrierWave file uploads
    class CarrierwaveFile < RailsAdmin::Config::Fields::Types::FileUpload
      RailsAdmin::Config::Fields::Types.register(self)

      register_instance_option(:partial) do
        :form_carrierwave_file
      end

      register_instance_option(:formatted_value) do
        # get the value stored in the db e.g. "smiley.png" instead of the files entire path
        # note we need to call `name.to_s` because attributes takes a string and name returns a symbol.
        bindings[:object].attributes[name.to_s]
      end
    end

    # Field type that supports CarrierWave file uploads with image preview
    class CarrierwaveImage < CarrierwaveFile
      RailsAdmin::Config::Fields::Types.register(self)

      register_instance_option(:partial) do
        :form_carrierwave_image
      end
    end
end