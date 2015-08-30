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
            value.present? ? enum.invert[value.to_i] : nil
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name]
          end
        end
      end
    end
  end
end
