require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/enum'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if parent.abstract_model.model.instance_methods.include?(:"#{properties[:name]}_enum") || parent.abstract_model.model.instance_methods.include?("#{properties[:name]}_enum")
    fields << RailsAdmin::Config::Fields::Types::Enum.new(parent, properties[:name], properties)
    true
  else
    false
  end
end
