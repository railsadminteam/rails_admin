require 'builder'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Boolean < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option :view_helper do
            :check_box
          end

          register_instance_option :formatted_value do
            case value
            when nil
              %{<span class="badge">-</span>}
            when false
              %{<span class="badge badge-important">&#x2718;</span>}
            when true
              %{<span class="badge badge-success">&#x2713;</span>}
            end.html_safe
          end

          register_instance_option :export_value do
            value.inspect
          end

          # Accessor for field's help text displayed below input field.
          register_instance_option :help do
            ""
          end
        end
      end
    end
  end
end
