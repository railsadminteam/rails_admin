# frozen_string_literal: true

require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

RailsAdmin::AbstractModel.register_classifier do |model, property|
  next unless defined?(::Shrine)

  attachment_names = model.ancestors.select { |ancestor| ancestor.is_a?(Shrine::Attachment) }.map { |a| a.instance_variable_get('@name') }
  next if attachment_names.blank?

  attachment_name = attachment_names.detect { |name| name == property.name.to_s.chomp('_data').to_sym }
  next unless attachment_name

  RailsAdmin::AbstractModel::Role.new(
    kind: :shrine,
    name: attachment_name,
    children: [:"#{attachment_name}_data"],
  )
end

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  role = properties.try(:role)
  next false unless role&.kind == :shrine

  field = RailsAdmin::Config::Fields::Types.load(:shrine).new(parent, role.name, properties)
  fields << field

  data_field_name = role.children.first
  child_properties = parent.abstract_model.properties.detect { |p| p.name == data_field_name }
  next true unless child_properties

  children_field = fields.detect { |f| f.name == data_field_name } || RailsAdmin::Config::Fields.default_factory.call(parent, child_properties, fields)
  children_field.hide unless field == children_field
  children_field.filterable(false) unless field == children_field

  field.children_fields([data_field_name])
  true
end
