

require 'mongoid'

module RailsAdmin
  module Adapters
    module Mongoid
      class Bson
        OBJECT_ID =
          if defined?(Moped::BSON)
            Moped::BSON::ObjectId
          elsif defined?(BSON::ObjectId)
            BSON::ObjectId
          end

        class << self
          def parse_object_id(value)
            OBJECT_ID.from_string(value)
          rescue StandardError => e
            raise e if %w[
              Moped::Errors::InvalidObjectId
              BSON::ObjectId::Invalid
              BSON::InvalidObjectId
              BSON::Error::InvalidObjectId
            ].exclude?(e.class.to_s)
          end
        end
      end
    end
  end
end
