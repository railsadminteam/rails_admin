require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/enum'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if parent.abstract_model.model.respond_to?("#{properties[:name]}_enum") || parent.abstract_model.model.method_defined?("#{properties[:name]}_enum")
    fields << RailsAdmin::Config::Fields::Types::Enum.new(parent, properties[:name], properties)
    true
  else
    false
  end
end
