# frozen_string_literal: true

require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/enum'
require 'rails_admin/config/fields/types/active_record_enum'

RailsAdmin::AbstractModel.register_classifier do |model, property|
  method_name = "#{property.name}_enum"

  # NOTICE: method_name could be `to_enum` and this method defined in Object.
  if !Object.respond_to?(method_name) && (model.respond_to?(method_name) || model.method_defined?(method_name))
    RailsAdmin::AbstractModel::Role.new(kind: :enum, name: property.name)
  elsif model.respond_to?(:defined_enums) && model.defined_enums[property.name.to_s]
    RailsAdmin::AbstractModel::Role.new(kind: :active_record_enum, name: property.name)
  end
end

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  case properties.try(:role)&.kind
  when :enum
    fields << RailsAdmin::Config::Fields::Types::Enum.new(parent, properties.name, properties)
    true
  when :active_record_enum
    fields << RailsAdmin::Config::Fields::Types::ActiveRecordEnum.new(parent, properties.name, properties)
    true
  else
    false
  end
end
