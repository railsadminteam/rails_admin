module RailsAdmin
  module Config
    module Fields
      module Types
        class Boolean < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :view_helper do
            :check_box
          end

          register_instance_option :pretty_value do
            case value
            when nil
              %(<span class='label label-default'>&#x2012;</span>)
            when false
              %(<span class='label label-danger'>&#x2718;</span>)
            when true
              %(<span class='label label-success'>&#x2713;</span>)
            end.html_safe
          end

          register_instance_option :export_value do
            value.inspect
          end

          register_instance_option :partial do
            :form_boolean
          end

          # Accessor for field's help text displayed below input field.
          def generic_help
            ''
          end
        end
      end
    end
  end
end
