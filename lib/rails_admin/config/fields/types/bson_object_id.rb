require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BsonObjectId < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:column_width) do
            100
          end

          register_instance_option(:help) do
            "BSON::ObjectId"
          end
        end
      end
    end
  end
end



