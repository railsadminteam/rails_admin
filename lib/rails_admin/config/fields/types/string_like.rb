require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class StringLike < RailsAdmin::Config::Fields::Base
          register_instance_option :treat_empty_as_nil? do
            properties.try(:nullable?)
          end

          register_instance_option :strip_value? do
            false
          end
        
          def parse_value(value)
            if value.present? && strip_value?
              value.strip
            else
              value
            end
          end

          def parse_input(params)
            params[name] = params[name].presence if params.key?(name) && treat_empty_as_nil?
          end
        end
      end
    end
  end
end
