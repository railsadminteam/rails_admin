require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/types/file_upload'

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|

  if (properties[:name].to_s =~ /^(.+)_uid$/) && defined?(::Dragonfly) && parent.abstract_model.model.dragonfly_attachment_classes.map(&:attribute).include?(attachment_name = $1.to_sym)
    additionnal_dragonfly_columns = [:name]
    additionnal_dragonfly_columns.each do |it|
      if props = parent.abstract_model.properties.find {|p| "#{attachment_name}_#{it}" == p[:name].to_s }
        RailsAdmin::Config::Fields.default_factory.call(parent, props, fields)
        fields.last.hide
        fields.last.filterable(false)
      end
    end
    fields << RailsAdmin::Config::Fields::Types::Dragonfly.new(parent, attachment_name, properties)
    true
  else
    false
  end
end
