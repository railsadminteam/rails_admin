# frozen_string_literal: true

require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

RailsAdmin::AbstractModel.register_classifier do |model, property|
  next unless defined?(::Dragonfly)
  next unless (match = /^(.+)_uid$/.match(property.name.to_s))
  next unless model.respond_to?(:dragonfly_attachment_classes)

  attachment_name = match[1].to_sym
  next unless model.dragonfly_attachment_classes.collect(&:attribute).include?(attachment_name)

  RailsAdmin::AbstractModel::Role.new(
    kind: :dragonfly,
    name: attachment_name,
    children: %i[name uid].map { |ext| :"#{attachment_name}_#{ext}" },
  )
end

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  role = properties.try(:role)
  next false unless role&.kind == :dragonfly

  field = RailsAdmin::Config::Fields::Types.load(:dragonfly).new(parent, role.name, properties)
  children_fields = []
  role.children.each do |children_column_name|
    child_properties = parent.abstract_model.properties.detect { |p| p.name.to_s == children_column_name.to_s }
    next unless child_properties

    children_field = fields.detect { |f| f.name == children_column_name } || RailsAdmin::Config::Fields.default_factory.call(parent, child_properties, fields)
    children_field.hide
    children_field.filterable(false)
    children_fields << children_field.name
  end
  field.children_fields(children_fields)
  fields << field
  true
end
