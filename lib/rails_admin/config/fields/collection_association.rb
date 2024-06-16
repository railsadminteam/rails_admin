# frozen_string_literal: true

require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      class CollectionAssociation < Association
        # orderable associated objects
        register_instance_option :orderable do
          false
        end

        register_instance_option :partial do
          nested_form ? :form_nested_many : :form_filtering_multiselect
        end

        def collection(scope = nil)
          if scope
            super
          elsif associated_collection_cache_all
            selected = selected_ids
            i = 0
            super.sort_by { |a| [selected.index(a[1]) || selected.size, i += 1] }
          else
            value.map { |o| [o.send(associated_object_label_method), format_key(o.send(associated_primary_key))] }
          end
        end

        def associated_prepopulate_params
          {associated_model_config.abstract_model.param_key => {association.foreign_key => bindings[:object].try(:id)}}
        end

        def multiple?
          true
        end

        def selected_ids
          value.map { |s| format_key(s.send(associated_primary_key)).to_s }
        end

        def parse_input(params)
          return unless associated_model_config.abstract_model.primary_key.is_a?(Array)

          if nested_form
            params[method_name].each_value do |value|
              value[:id] = associated_model_config.abstract_model.parse_id(value[:id])
            end
          elsif params[method_name].is_a?(Array)
            params[method_name] = params[method_name].map { |key| associated_model_config.abstract_model.parse_id(key) if key.present? }.compact
            if params[method_name].empty?
              # Workaround for Arel::Visitors::UnsupportedVisitError in #ids_writer, until https://github.com/rails/rails/pull/51116 is in place
              params.delete(method_name)
              params[name] = []
            end
          end
        end

        def form_default_value
          (default_value if bindings[:object].new_record? && value.empty?)
        end

        def form_value
          form_default_value.nil? ? selected_ids : form_default_value
        end

        def widget_options
          {
            xhr: !associated_collection_cache_all,
            'edit-url': (inline_edit && bindings[:view].authorized?(:edit, associated_model_config.abstract_model) ? bindings[:view].edit_path(model_name: associated_model_config.abstract_model.to_param, id: '__ID__') : ''),
            remote_source: bindings[:view].index_path(associated_model_config.abstract_model, source_object_id: abstract_model.format_id(bindings[:object].id), source_abstract_model: abstract_model.to_param, associated_collection: name, current_action: bindings[:view].current_action, compact: true),
            scopeBy: dynamic_scope_relationships,
            sortable: !!orderable,
            removable: !!removable,
            cacheAll: !!associated_collection_cache_all,
            regional: {
              add: ::I18n.t('admin.misc.add_new'),
              chooseAll: ::I18n.t('admin.misc.chose_all'),
              clearAll: ::I18n.t('admin.misc.clear_all'),
              down: ::I18n.t('admin.misc.down'),
              remove: ::I18n.t('admin.misc.remove'),
              search: ::I18n.t('admin.misc.search'),
              up: ::I18n.t('admin.misc.up'),
            },
          }
        end
      end
    end
  end
end
