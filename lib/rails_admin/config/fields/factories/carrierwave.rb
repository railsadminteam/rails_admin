# frozen_string_literal: true

require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

RailsAdmin::AbstractModel.register_classifier do |model, property|
  next unless defined?(::CarrierWave)
  next unless model.is_a?(CarrierWave::Mount)

  attachment_name = property.name.to_s.chomp('_file_name').to_sym
  next unless model.uploaders.include?(attachment_name)

  RailsAdmin::AbstractModel::Role.new(
    kind: :carrierwave,
    name: attachment_name,
    children: [
      model.uploader_options[attachment_name][:mount_on] || attachment_name,
      :"#{attachment_name}_content_type",
      :"#{attachment_name}_file_size",
    ],
  )
end

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  role = properties.try(:role)
  next false unless role&.kind == :carrierwave

  field = RailsAdmin::Config::Fields::Types.load(
    %i[serialized json].include?(properties.type) ? :multiple_carrierwave : :carrierwave,
  ).new(parent, role.name, properties)
  fields << field
  children_fields = []
  role.children.each do |children_column_name|
    child_properties = parent.abstract_model.properties.detect { |p| p.name.to_s == children_column_name.to_s }
    next unless child_properties

    children_field = fields.detect { |f| f.name == children_column_name } || RailsAdmin::Config::Fields.default_factory.call(parent, child_properties, fields)
    children_field.hide unless field == children_field
    children_field.filterable(false) unless field == children_field
    children_fields << children_field.name
  end
  field.children_fields(children_fields)
  true
end
