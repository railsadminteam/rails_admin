# frozen_string_literal: true

require 'rails_admin/config'
require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      class Association < RailsAdmin::Config::Fields::Base
        # Reader for the association information hash
        def association
          @properties
        end

        def method_name
          nested_form ? :"#{name}_attributes" : association.key_accessor
        end

        register_instance_option :pretty_value do
          v = bindings[:view]
          [value].flatten.select(&:present?).collect do |associated|
            amc = polymorphic? ? RailsAdmin.config(associated) : associated_model_config # perf optimization for non-polymorphic associations
            am = amc.abstract_model
            wording = associated.send(amc.object_label_method)
            can_see = !am.embedded? && (show_action = v.action(:show, am, associated))
            can_see ? v.link_to(wording, v.url_for(action: show_action.action_name, model_name: am.to_param, id: associated.id)) : ERB::Util.html_escape(wording)
          end.to_sentence.html_safe.presence || '-'
        end

        # Accessor whether association is visible or not. By default
        # association checks whether the child model is excluded in
        # configuration or not.
        register_instance_option :visible? do
          @visible ||= !associated_model_config.excluded?
        end

        # use the association name as a key, not the association key anymore!
        register_instance_option :label do
          (@label ||= {})[::I18n.locale] ||= abstract_model.model.human_attribute_name association.name
        end

        # scope for possible associable records
        register_instance_option :associated_collection_scope do
          # bindings[:object] & bindings[:controller] available
          associated_collection_scope_limit = (associated_collection_cache_all ? nil : 30)
          proc do |scope|
            scope.limit(associated_collection_scope_limit)
          end
        end

        # inverse relationship
        register_instance_option :inverse_of do
          association.inverse_of
        end

        # preload entire associated collection (per associated_collection_scope) on load
        # Be sure to set limit in associated_collection_scope if set is large
        register_instance_option :associated_collection_cache_all do
          @associated_collection_cache_all ||= dynamically_scope_by.blank? && (associated_model_config.abstract_model.count < associated_model_limit)
        end

        # client-side dynamic scoping
        register_instance_option :dynamically_scope_by do
          nil
        end

        # parses #dynamically_scope_by and returns a Hash in the form of
        # {[form field name in this model]: [field name in the associated model]}
        def dynamic_scope_relationships
          @dynamic_scope_relationships ||=
            Array.wrap(dynamically_scope_by).flat_map do |field|
              field.is_a?(Hash) ? field.to_a : [[field, field]]
            end.map do |field_name, target_name| # rubocop:disable Style/MultilineBlockChain
              field = section.fields.detect { |f| f.name == field_name }
              raise "Field '#{field_name}' was given for #dynamically_scope_by but not found in '#{abstract_model.model_name}'" unless field

              target_field = associated_model_config.list.fields.detect { |f| f.name == target_name }
              raise "Field '#{field_name}' was given for #dynamically_scope_by but not found in '#{associated_model_config.abstract_model.model_name}'" unless target_field
              raise "Field '#{field_name}' in '#{associated_model_config.abstract_model.model_name}' can't be used for dynamic scoping because it's not filterable" unless target_field.filterable

              [field.method_name, target_name]
            end.to_h
        end

        # determines whether association's elements can be removed
        register_instance_option :removable? do
          association.foreign_key_nullable?
        end

        register_instance_option :eager_load do
          !!searchable
        end

        register_instance_option :inline_add do
          true
        end

        register_instance_option :inline_edit do
          true
        end

        # Reader for the association's child model's configuration
        def associated_model_config
          @associated_model_config ||= RailsAdmin.config(association.klass)
        end

        # Reader for the association's child model object's label method
        def associated_object_label_method
          @associated_object_label_method ||= associated_model_config.object_label_method
        end

        # Reader for associated primary key
        def associated_primary_key
          association.primary_key
        end

        # Returns params which are to be set in modals
        def associated_prepopulate_params
          {}
        end

        # Reader whether this is a polymorphic association
        def polymorphic?
          association.polymorphic?
        end

        # Reader for nested attributes
        register_instance_option :nested_form do
          association.nested_options
        end

        # Reader for the association's value unformatted
        def value
          bindings[:object].send(association.name)
        end

        # Returns collection of all selectable records
        def collection(scope = nil)
          (scope || bindings[:controller].list_entries(associated_model_config, :index, associated_collection_scope, false)).
            map { |o| [o.send(associated_object_label_method), format_key(o.send(associated_primary_key)).to_s] }
        end

        # has many?
        def multiple?
          true
        end

        def virtual?
          true
        end

        def associated_model_limit
          RailsAdmin.config.default_associated_collection_limit
        end

      private

        def format_key(key)
          if key.is_a?(Array)
            RailsAdmin.config.composite_keys_serializer.serialize(key)
          else
            key
          end
        end
      end
    end
  end
end
