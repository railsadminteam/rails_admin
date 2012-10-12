require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BsonObjectId < RailsAdmin::Config::Fields::Types::String
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option :label do
            label = ((@label ||= {})[::I18n.locale] ||= abstract_model.model.human_attribute_name name)
            label = "Id" if label == ''
            label
          end

          register_instance_option :help do
            "BSON::ObjectId"
          end

          register_instance_option :read_only do
            true
          end

          register_instance_option :sort_reverse? do
            serial?
          end

          def parse_input(params)
            begin
              params[name] = (params[name].blank? ? nil : abstract_model.object_id_from_string(params[name])) if params[name].is_a?(::String)
            rescue => e
              unless ['BSON::InvalidObjectId', 'Moped::Errors::InvalidObjectId'].include? e.class.to_s
                raise e
              end
            end
          end
        end
      end
    end
  end
end



