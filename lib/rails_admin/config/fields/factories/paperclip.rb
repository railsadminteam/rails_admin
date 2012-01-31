require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  extensions = [:file_name, :content_type, :file_size, :updated_at]
  model = parent.abstract_model.model
  if (properties[:name].to_s =~ /^(.+)_file_name$/) and defined?(::Paperclip) and model.attachment_definitions and model.attachment_definitions.has_key?(attachment_name = $1.to_sym)
    field = RailsAdmin::Config::Fields::Types.load(:paperclip).new(parent, attachment_name, properties)
    children_fields = []
    extensions.each do |ext|
      children_column_name = "#{attachment_name}_#{ext}".to_sym
      if child_properties = parent.abstract_model.properties.find {|p| p[:name].to_s == children_column_name.to_s }
        children_field = fields.find{ |f| f.name == children_column_name } || RailsAdmin::Config::Fields.default_factory.call(parent, child_properties, fields)
        children_field.hide
        children_field.filterable(false)
        children_fields << children_field.name
      end
    end
    field.children_fields(children_fields)
    fields << field
    true
  else
    false
  end
end
