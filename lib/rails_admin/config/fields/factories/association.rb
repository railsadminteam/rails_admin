

require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/belongs_to_association'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  parent.abstract_model.associations.filter { |a| Array(a.foreign_key).include?(properties.name) && %i[belongs_to has_and_belongs_to_many].include?(a.type) }.each do |association|
    field = RailsAdmin::Config::Fields::Types.load(association.field_type).new(parent, association.name, association)
    fields << field

    child_columns = []
    possible_field_names = if association.polymorphic?
                             %i[foreign_key foreign_type foreign_inverse_of]
                           else
                             [:foreign_key]
                           end.flat_map { |k| Array(association.send(k)) }.compact

    parent.abstract_model.properties.select { |p| possible_field_names.include? p.name }.each do |column|
      child_field = fields.detect { |f| f.name.to_s == column.name.to_s }
      child_field ||= RailsAdmin::Config::Fields.default_factory.call(parent, column, fields)
      child_columns << child_field
    end

    child_columns.each do |child_column|
      child_column.hide
      child_column.filterable(false)
    end

    field.children_fields child_columns.collect(&:name)
  end.any?
end
