require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasManyAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          # Accessor for field's help text displayed below input field.
          register_instance_option(:help) do
            ""
          end

          register_instance_option(:partial) do
            "form_filtering_multiselect"
          end

          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil}",
              :multiple => "multiple",
            }
          end

          def selected(params)
            if params["associations"]
              params["associations"][association[:name]].to_a.map{|o| o.to_i}
            else
              bindings[:object].send(association[:name]).map{|o| o.id }
            end
          end
        end
      end
    end
  end
end