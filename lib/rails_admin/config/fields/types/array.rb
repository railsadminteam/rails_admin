require 'rails_admin/config/fields/types/enum'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Array < RailsAdmin::Config::Fields::Types::Enum
          RailsAdmin::Config::Fields::Types.register(self)

          def parse_value(value)
            (value || []).select(&:present?)
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name]
          end

          register_instance_option :multiple? do
            true
          end
        end
      end
    end
  end
end
