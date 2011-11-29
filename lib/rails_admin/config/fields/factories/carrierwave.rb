require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if defined?(::CarrierWave) && (model = parent.abstract_model.model).kind_of?(CarrierWave::Mount) && model.uploaders.include?(properties[:name])
    fields << RailsAdmin::Config::Fields::Types.load(:carrierwave).new(parent, properties[:name], properties)
    true
  else
    false
  end
end
