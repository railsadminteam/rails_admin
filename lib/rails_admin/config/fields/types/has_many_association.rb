require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasManyAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option :partial do
            nested_form ? :form_nested_many : :form_filtering_multiselect
          end

          # orderable associated objects
          register_instance_option :orderable do
            false
          end

          register_instance_option :inline_add do
            true
          end

          def method_name
            nested_form ? "#{super}_attributes".to_sym : "#{super.to_s.singularize}_ids".to_sym  # name_ids
          end

          # Reader for validation errors of the bound object
          def errors
            bindings[:object].errors[name]
          end
        end
      end
    end
  end
end
