require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/password'
require 'rails_admin/config/sections/update'

# Register a custom field factory for devise model
RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if :encrypted_password == properties[:name]
    fields << RailsAdmin::Config::Fields::Types.load(:password).new(parent, :password, properties)
    fields << RailsAdmin::Config::Fields::Types.load(:password).new(parent, :password_confirmation, properties)
    [:password_salt, :reset_password_token, :remember_token].each do |name|
      properties = parent.abstract_model.properties.find {|p| name == p[:name]}
      if properties
        RailsAdmin::Config::Fields.default_factory.call(parent, properties, fields)
        fields.last.hide
      end
    end
    if parent.kind_of?(RailsAdmin::Config::Sections::Update)
      [:remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip].each do |name|
        properties = parent.abstract_model.properties.find {|p| name == p[:name]}
        if properties
          RailsAdmin::Config::Fields.default_factory.call(parent, properties, fields)
          fields.last.hide
        end
      end
    end
    true
  else
    false
  end
end
