# frozen_string_literal: true

require 'rails_admin/config/fields/types/belongs_to_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class PolymorphicAssociation < RailsAdmin::Config::Fields::Types::BelongsToAssociation
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :partial do
            :form_polymorphic_association
          end

          # Accessor whether association is visible or not. By default
          # association checks that any of the child models are included in
          # configuration.
          register_instance_option :visible? do
            associated_model_config.any?
          end

          register_instance_option :formatted_value do
            (o = value) && o.send(RailsAdmin.config(o).object_label_method)
          end

          register_instance_option :sortable do
            false
          end

          register_instance_option :searchable do
            false
          end

          # TODO: not supported yet
          register_instance_option :associated_collection_cache_all do
            false
          end

          # TODO: not supported yet
          register_instance_option :associated_collection_scope do
            nil
          end

          register_instance_option :allowed_methods do
            [children_fields]
          end

          register_instance_option :eager_load do
            false
          end

          def associated_model_config
            @associated_model_config ||= association.klass.collect { |type| RailsAdmin.config(type) }.reject(&:excluded?)
          end

          def collection(_scope = nil)
            if value
              [[formatted_value, selected_id]]
            else
              [[]]
            end
          end

          def type_column
            association.foreign_type.to_s
          end

          def type_collection
            associated_model_config.collect do |config|
              [config.label, config.abstract_model.model.name]
            end
          end

          def type_urls
            types = associated_model_config.collect do |config|
              [config.abstract_model.model.name, config.abstract_model.to_param]
            end
            ::Hash[*types.collect { |v| [v[0], bindings[:view].index_path(v[1])] }.flatten]
          end

          # Reader for field's value
          def value
            bindings[:object].send(association.name)
          end

          def widget_options_for_types
            type_collection.inject({}) do |options, model|
              options.merge(
                model.second.downcase.gsub('::', '-') => {
                  xhr: true,
                  remote_source: bindings[:view].index_path(model.second.underscore, source_object_id: bindings[:object].id, source_abstract_model: abstract_model.to_param, current_action: bindings[:view].current_action, compact: true),
                  float_left: false,
                },
              )
            end
          end

          def widget_options
            widget_options_for_types[selected_type.try(:downcase)] || {float_left: false}
          end

          def selected_type
            bindings[:object].send(type_column)
          end

          def parse_input(params)
            if (type_value = params[association.foreign_type.to_sym]).present?
              config = associated_model_config.find { |c| type_value == c.abstract_model.model.name }
              params[association.foreign_type.to_sym] = config.abstract_model.base_class.name if config
            end
          end
        end
      end
    end
  end
end
