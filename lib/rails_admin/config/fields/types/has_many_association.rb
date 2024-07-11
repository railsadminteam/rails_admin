

require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasManyAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :partial do
            nested_form ? :form_nested_many : :form_filtering_multiselect
          end

          # orderable associated objects
          register_instance_option :orderable do
            false
          end

          def method_name
            nested_form ? :"#{name}_attributes" : super
          end

          # Reader for validation errors of the bound object
          def errors
            bindings[:object].errors[name]
          end

          def associated_prepopulate_params
            {associated_model_config.abstract_model.param_key => {association.foreign_key => bindings[:object].try(:id)}}
          end
        end
      end
    end
  end
end
