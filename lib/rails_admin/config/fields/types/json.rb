require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Json < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)
          RailsAdmin::Config::Fields::Types.register(:jsonb, self)

          PARSABLE_CLASSES = %w(String ActiveSupport::SafeBuffer).freeze

          register_instance_option :formatted_value do
            if value.present?
              bindings[:view].content_tag(:pre) { JSON.pretty_generate(value) }.html_safe
            end
          end

          def parse_value(value)
            value.present? ? JSON.parse(value) : nil
          end

          def parse_input(params)
            return unless PARSABLE_CLASSES.include?(params[name].class.name)
            params[name] = parse_value(params[name])
          end

          register_instance_option :formatted_value do
            value
          end

          # output for pretty printing (show, list)
          register_instance_option :pretty_value do
            JSON.pretty_generate(parse_value(value)).presence || ' - '
          end

          # output for printing in export view (developers beware: no bindings[:view] and no data!)
          register_instance_option :export_value do
            formatted_value.presence || ' - '
          end
        end
      end
    end
  end
end
