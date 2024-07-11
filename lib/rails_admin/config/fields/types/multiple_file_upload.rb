

module RailsAdmin
  module Config
    module Fields
      module Types
        class MultipleFileUpload < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types.register(self)

          class AbstractAttachment
            include RailsAdmin::Config::Proxyable
            include RailsAdmin::Config::Configurable

            attr_reader :value

            def initialize(value)
              @value = value
            end

            register_instance_option :thumb_method do
              nil
            end

            register_instance_option :keep_value do
              nil
            end

            register_instance_option :delete_value do
              nil
            end

            register_deprecated_instance_option :delete_key, :delete_value

            register_instance_option :pretty_value do
              if value.presence
                v = bindings[:view]
                url = resource_url
                if image
                  thumb_url = resource_url(thumb_method)
                  image_html = v.image_tag(thumb_url, class: 'img-thumbnail')
                  url == thumb_url ? image_html : v.link_to(image_html, url, target: '_blank', rel: 'noopener noreferrer')
                else
                  display_value = value.respond_to?(:filename) ? value.filename : value
                  v.link_to(display_value, url, target: '_blank', rel: 'noopener noreferrer')
                end
              end
            end

            register_instance_option :image? do
              mime_type = Mime::Type.lookup_by_extension(resource_url.to_s.split('.').last)
              mime_type.to_s.match?(/^image/)
            end

            def resource_url(_thumb = false)
              raise 'not implemented'
            end
          end

          def initialize(*args)
            super
            @attachment_configurations = []
          end

          register_instance_option :attachment_class do
            AbstractAttachment
          end

          register_instance_option :partial do
            :form_multiple_file_upload
          end

          register_instance_option :cache_method do
            nil
          end

          register_instance_option :delete_method do
            nil
          end

          register_instance_option :keep_method do
            nil
          end

          register_instance_option :reorderable? do
            false
          end

          register_instance_option :export_value do
            attachments.map(&:resource_url).map(&:to_s).join(',')
          end

          register_instance_option :pretty_value do
            bindings[:view].safe_join attachments.map(&:pretty_value), ' '
          end

          register_instance_option :allowed_methods do
            [method_name, cache_method, delete_method].compact
          end

          register_instance_option :html_attributes do
            {
              required: required? && !value.present?,
            }
          end

          def attachment(&block)
            @attachment_configurations << block
          end

          def attachments
            Array(value).map do |attached|
              attachment = attachment_class.new(attached)
              @attachment_configurations.each do |config|
                attachment.instance_eval(&config)
              end
              attachment.with(bindings)
            end
          end

          # virtual class
          def virtual?
            true
          end
        end
      end
    end
  end
end
