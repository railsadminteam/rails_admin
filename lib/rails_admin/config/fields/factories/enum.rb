require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/enum'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|

  _model = parent.abstract_model.model
  _method_name = "#{properties[:name]}_enum"

  #NOTICE: _method_name could be `to_enum` and this method defined in Object.
  if !Object.respond_to?(_method_name) && \
      (_model.respond_to?(_method_name) || \
          _model.method_defined?(_method_name))
    fields << RailsAdmin::Config::Fields::Types::Enum.new(parent, properties[:name], properties)
    true
  else
    false
  end
end
