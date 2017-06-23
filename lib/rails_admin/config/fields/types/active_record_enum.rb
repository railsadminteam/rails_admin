require 'rails_admin/config/fields/types/enum'

module RailsAdmin
  module Config
    module Fields
      module Types
        class ActiveRecordEnum < Enum
          RailsAdmin::Config::Fields::Types.register(self)

          def type
            :enum
          end

          register_instance_option :enum do
            abstract_model.model.defined_enums[name.to_s]
          end

          register_instance_option :pretty_value do
            bindings[:object].send(name).presence || ' - '
          end

          register_instance_option :multiple? do
            false
          end

          register_instance_option :queryable do
            false
          end

          def parse_value(value)
            return unless value.present?
            if ::Rails.version >= '5'
              abstract_model.model.attribute_types[name.to_s].deserialize(value)
            else
              enum.invert[type_cast_value(value)]
            end
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name]
          end

          def form_value
            enum[super] || super
          end

        private

          def type_cast_value(value)
            if ::Rails.version >= '4.2'
              abstract_model.model.column_types[name.to_s].type_cast_from_user(value)
            else
              abstract_model.model.column_types[name.to_s].type_cast(value)
            end
          end
        end
      end
    end
  end
end
