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
            :form_filtering_multiselect
          end

          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil}",
              :multiple => "multiple",
            }
          end

          # orderable associated objects
          register_instance_option(:orderable) do
            false
          end

          def dom_name
            "#{super}[]" # model_name[name_ids][]
          end

          def method_name
            "#{super.to_s.singularize}_ids" # name_ids
          end
        end
      end
    end
  end
end
