# frozen_string_literal: true

require 'yaml'
require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Serialized < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          # The text an admin edits carries no Ruby class name, which is also
          # all that is read back out of it.
          PERMITTED_CLASSES = [::Symbol, ::Date, ::Time].freeze

          register_instance_option :formatted_value do
            YAML.dump(plain_value(value)) unless value.nil?
          end

          def parse_value(value)
            value.present? ? (YAML.safe_load(value, permitted_classes: PERMITTED_CLASSES) || nil) : nil
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name].is_a?(::String)
          end

        private

          # A value may come in a class which only wraps a plain hash or array:
          # ActiveRecord::Store's HashWithIndifferentAccess, a BSON::Document.
          def plain_value(value)
            case value
            when ::Hash then value.to_h { |key, item| [key, plain_value(item)] }
            when ::Array then value.collect { |item| plain_value(item) }
            else value
            end
          end
        end
      end
    end
  end
end
