require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/enum'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  model = parent.abstract_model.model
  method_name = "#{properties.name}_enum"

  # NOTICE: _method_name could be `to_enum` and this method defined in Object.
  if !Object.respond_to?(method_name) && \
     (model.respond_to?(method_name) || \
         model.method_defined?(method_name))
    fields << RailsAdmin::Config::Fields::Types::Enum.new(parent, properties.name, properties)
    true
  else
    false
  end
end
