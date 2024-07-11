

module RailsAdmin
  module Config
    module Fields
      module Types
        class Boolean < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :labels do
            {
              true => %(<span class="fas fa-check"></span>),
              false => %(<span class="fas fa-times"></span>),
              nil => %(<span class="fas fa-minus"></span>),
            }
          end

          register_instance_option :css_classes do
            {
              true => 'success',
              false => 'danger',
              nil => 'default',
            }
          end

          register_instance_option :filter_operators do
            %w[_discard true false] + (required? ? [] : %w[_separator _present _blank])
          end

          register_instance_option :nullable? do
            properties&.nullable?
          end

          register_instance_option :view_helper do
            :check_box
          end

          register_instance_option :pretty_value do
            %(<span class="badge bg-#{css_classes[form_value]}">#{labels[form_value]}</span>).html_safe
          end

          register_instance_option :export_value do
            value.inspect
          end

          register_instance_option :partial do
            :form_boolean
          end

          def form_value
            case value
            when true, false
              value
            end
          end

          # Accessor for field's help text displayed below input field.
          def generic_help
            ''
          end

          def parse_input(params)
            params[name] = params[name].presence if params.key?(name)
          end
        end
      end
    end
  end
end
