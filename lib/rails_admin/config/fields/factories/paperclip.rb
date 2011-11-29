require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

# Register a custom field factory
RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  paperclip_columns = [:file_name, :content_type, :file_size, :updated_at]
  model = parent.abstract_model.model
  if defined?(::Paperclip) and model.kind_of?(Paperclip::ClassMethods)
    if part = paperclip_columns.detect {|it| properties[:name].to_s.strip =~ /^(.+)_#{it}$/ }
      attachment_name = properties[:name].to_s.scan(/^(.+)_#{part}$/).first.first.to_sym
      if model.attachment_definitions && model.attachment_definitions.has_key?(attachment_name) && fields.find{|f| attachment_name == f.name}.nil?
        paperclip_columns.each do |it|
          if props = parent.abstract_model.properties.find {|p| "#{attachment_name}_#{it}" == p[:name].to_s }
            RailsAdmin::Config::Fields.default_factory.call(parent, props, fields)
            fields.last.hide
            fields.last.filterable(false)
          end
        end
        fields << RailsAdmin::Config::Fields::Types::Paperclip.new(parent, attachment_name, properties)
        true
      end
    end
  else
    false
  end
end
