require 'rails_admin/config/fields/base'
require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        # Field type that supports Paperclip file uploads
        class PaperclipFile < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option(:partial) do
            :form_paperclip_file
          end

          register_instance_option(:delete_method) do
            "delete_#{name}" if bindings[:object].respond_to?("delete_#{name}")
          end

          register_instance_option(:thumb_method) do
            nil
          end
          
          register_instance_option(:export_value) do
            value.to_s
          end
          
          # Reader for validation errors of the bound object
          def errors
            bindings[:object].errors["#{name}_file_name"] + bindings[:object].errors["#{name}_content_type"] + bindings[:object].errors["#{name}_file_size"]
          end
          
          register_instance_option(:required?) do
            @required ||= !!abstract_model.model.validators_on("#{name}_file_name").find do |v|
              v.is_a?(ActiveModel::Validations::PresenceValidator) || !v.options[:allow_nil]
            end
          end

          register_instance_option(:pretty_value) do
            if (file = bindings[:object].send(method_name))
              if file.file? && errors.blank?
                url = file.url
                v = bindings[:view]
                if file.content_type =~ /image/ || file.to_s.split('.').last =~ /jpg|jpeg|png|gif/
                  thumb_url = (self.thumb_method && file.url(self.thumb_method) || url)
                  (url != thumb_url) ? v.link_to(v.image_tag(thumb_url), url, :target => 'blank') : v.image_tag(thumb_url)
                else
                  v.link_to(nil, url, :target => 'blank')
                end
              end
            else
              file.to_s + " [#{I18n.t('admin.show.no_file_found')}]"
            end
          end

          def value
            if bindings[:object].send(name).file?
              bindings[:object].send(name).url
            else
              nil
            end
          end
        end
      end
    end
  end
end
