# frozen_string_literal: true

require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      class SingularAssociation < Association
        register_instance_option :filter_operators do
          %w[_discard like not_like is starts_with ends_with] + (required? ? [] : %w[_separator _present _blank])
        end

        register_instance_option :formatted_value do
          (o = value) && o.send(associated_model_config.object_label_method)
        end

        register_instance_option :partial do
          nested_form ? :form_nested_one : :form_filtering_select
        end

        def collection(scope = nil)
          if associated_collection_cache_all || scope
            super
          else
            [[formatted_value, selected_id]]
          end
        end

        def multiple?
          false
        end

        def selected_id
          raise NoMethodError # abstract
        end

        def form_value
          form_default_value.nil? ? selected_id : form_default_value
        end

        def widget_options
          {
            xhr: !associated_collection_cache_all,
            remote_source: bindings[:view].index_path(associated_model_config.abstract_model, source_object_id: bindings[:object].id, source_abstract_model: abstract_model.to_param, associated_collection: name, current_action: bindings[:view].current_action, compact: true),
            scopeBy: dynamic_scope_relationships,
          }
        end
      end
    end
  end
end
