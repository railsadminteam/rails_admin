require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/belongs_to_association'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if association = parent.abstract_model.associations.find {|a| a[:foreign_key] == properties[:name] }
    field = RailsAdmin::Config::Fields::Types.load("#{association[:polymorphic] ? :polymorphic : association[:type]}_association").new(parent, association[:name], association)
    fields << field

    child_columns = []
    id_column = parent.abstract_model.properties.find {|p| p[:name].to_s == association[:foreign_key].to_s }
    child_columns << RailsAdmin::Config::Fields.default_factory.call(parent, id_column, fields)

    if association[:polymorphic]
      type_colum = parent.abstract_model.properties.find {|p| p[:name].to_s == association[:foreign_type].to_s }
      unless type_field = fields.find{|f| f.name.to_s == type_colum[:name].to_s }
        type_field = RailsAdmin::Config::Fields.default_factory.call(parent, type_colum, fields)
      end
      child_columns << type_field
    end

    child_columns.each do |child_column|
      child_column.hide
      child_column.filterable(false)
    end

    field.children_fields child_columns.map(&:name)
  end
end
