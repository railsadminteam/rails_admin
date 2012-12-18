require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/belongs_to_association'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if association = parent.abstract_model.associations.find {|a| a[:foreign_key] == properties[:name] && [:belongs_to, :has_and_belongs_to_many].include?(a[:type]) }
    field = RailsAdmin::Config::Fields::Types.load("#{association[:polymorphic] ? :polymorphic : association[:type]}_association").new(parent, association[:name], association)
    fields << field

    child_columns = []
    possible_field_names =
      if association[:polymorphic]
        [:foreign_key, :foreign_type, :foreign_inverse_of]
      else
        [:foreign_key]
      end.map{|k| association[k] }.compact

    parent.abstract_model.properties.select{|p| possible_field_names.include? p[:name] }.each do |column|
      unless child_field = fields.find{|f| f.name.to_s == column[:name].to_s }
        child_field = RailsAdmin::Config::Fields.default_factory.call(parent, column, fields)
      end
      child_columns << child_field
    end

    child_columns.each do |child_column|
      child_column.hide
      child_column.filterable(false)
    end

    field.children_fields child_columns.map(&:name)
  end
end
