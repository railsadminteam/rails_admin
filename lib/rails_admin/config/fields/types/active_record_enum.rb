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

          def parse_input(params)
            if params[name].present?
              params[name] = enum.invert[params[name].to_i]
            elsif params[name]
              params[name] = nil
            end
          end
        end
      end
    end
  end
end
