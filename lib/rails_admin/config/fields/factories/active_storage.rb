require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if defined?(::ActiveStorage) && properties.is_a?(RailsAdmin::Adapters::ActiveRecord::Association) && (match = /\A(.+)_attachment\Z/.match properties.name) && properties.klass.to_s == 'ActiveStorage::Attachment'
    name = match[1]
    field = RailsAdmin::Config::Fields::Types.load(:active_storage).new(parent, name, properties)
    fields << field
    associations = ["#{name}_attachment".to_sym, "#{name}_blob".to_sym]
    children_fields = associations.map do |child_name|
      next unless child_association = parent.abstract_model.associations.detect { |p| p.name.to_sym == child_name }
      child_field = fields.detect { |f| f.name == child_name } || RailsAdmin::Config::Fields.default_factory.call(parent, child_association, fields)
      child_field.hide unless field == child_field
      child_field.filterable(false) unless field == child_field
      child_field.name
    end.flatten
    field.children_fields(children_fields)
    true
  else
    false
  end
end
