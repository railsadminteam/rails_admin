require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

# Register a custom field factory
RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  model = parent.abstract_model.model
  if defined?(::CarrierWave) && model.kind_of?(::CarrierWave::Mount) && model.uploaders.include?(properties[:name])
    type = properties[:name] =~ /image|picture|thumb/ ? :carrierwave_image : :carrierwave_file
    fields << RailsAdmin::Config::Fields::Types.load(type).new(parent, properties[:name], properties)
    true
  else
    false
  end
end