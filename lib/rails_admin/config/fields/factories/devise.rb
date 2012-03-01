require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/password'

# Register a custom field factory for devise model
RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if properties[:name] == :encrypted_password
    extensions = [:password_salt, :reset_password_token, :remember_token]
    model = parent.abstract_model.model

    fields << RailsAdmin::Config::Fields::Types.load(:password).new(parent, :password, properties)
    fields << RailsAdmin::Config::Fields::Types.load(:password).new(parent, :password_confirmation, properties)
    extensions.each do |ext|
      properties = parent.abstract_model.properties.find {|p| ext == p[:name]}
      if properties
        unless field = fields.find{ |f| f.name == ext }
          RailsAdmin::Config::Fields.default_factory.call(parent, properties, fields)
          field = fields.last
        end
        field.hide
      end
    end
    true
  else
    false
  end
end
