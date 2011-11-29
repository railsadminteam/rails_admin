require 'rails_admin/config/fields/base'
require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        # Field type that supports Paperclip file uploads
        class Paperclip < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option(:delete_method) do
            "delete_#{name}" if bindings[:object].respond_to?("delete_#{name}")
          end

          register_instance_option(:thumb_method) do
            @styles ||= bindings[:object].send(name).styles.map(&:first)
            @thumb_method ||= @styles.find{|s| [:thumb, 'thumb', :thumbnail, 'thumbnail'].include?(s)} || @styles.first || :original
          end

          register_instance_option(:required?) do
            @required ||= !!abstract_model.model.validators_on("#{name}_file_name").find do |v|
              v.is_a?(ActiveModel::Validations::PresenceValidator) && !v.options[:allow_nil]
            end
          end
          
          register_instance_option(:sortable) do
            "#{name}_file_name"
          end
          
          register_instance_option(:searchable) do
            "#{name}_file_name"
          end
          
          def resource_url(thumb = false)
            value.try(:url, (thumb || :original))
          end

          def errors
            bindings[:object].errors["#{name}_file_name"] + bindings[:object].errors["#{name}_content_type"] + bindings[:object].errors["#{name}_file_size"]
          end
        end
      end
    end
  end
end
