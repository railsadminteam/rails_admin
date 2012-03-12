require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BsonObjectId < RailsAdmin::Config::Fields::Types::String
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:label) do
            label = ((@label ||= {})[::I18n.locale] ||= abstract_model.model.human_attribute_name name)
            label = "_id" if label == ''
            label
          end

          register_instance_option(:help) do
            "BSON::ObjectId"
          end

          register_instance_option(:read_only) do
            true
          end

          register_instance_option(:visible?) do
            @name.to_s != '_id'
          end

          def parse_input(params)
            begin
              params[name] = (params[name].blank? ? nil : BSON::ObjectId(params[name])) if params[name].is_a?(::String)
            rescue BSON::InvalidObjectId
            end
          end
        end
      end
    end
  end
end



