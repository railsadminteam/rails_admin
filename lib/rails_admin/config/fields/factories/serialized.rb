require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/serialized'

# Register a custom field factory for properties named as password. More property
# names can be registered in RailsAdmin::Config::Fields::Password.column_names
# array.
#
# @see RailsAdmin::Config::Fields::Types::Password.column_names
# @see RailsAdmin::Config::Fields.register_factory
RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if parent.abstract_model.serialized_attributes.include?(properties[:name].to_s)
    fields << RailsAdmin::Config::Fields::Types::Serialized.new(parent, properties[:name], properties)
    true
  else
    false
  end
end
