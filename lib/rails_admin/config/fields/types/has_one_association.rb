# frozen_string_literal: true

require 'rails_admin/config/fields/singular_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasOneAssociation < RailsAdmin::Config::Fields::SingularAssociation
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :allowed_methods do
            nested_form ? [method_name] : [name]
          end

          def associated_prepopulate_params
            {associated_model_config.abstract_model.param_key => {association.foreign_key => bindings[:object].try(:id)}}
          end

          def parse_input(params)
            return super if nested_form

            id = params.delete(method_name)
            params[name] = associated_model_config.abstract_model.get(id) if id
          end

          def selected_id
            format_key(value.try(:id)).try(:to_s)
          end
        end
      end
    end
  end
end
