require 'rails_admin/config'
require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      class Association < RailsAdmin::Config::Fields::Base

        def self.inherited(klass)
          super(klass)
        end

        # Reader for the association information hash
        def association
          @properties
        end

        register_instance_option(:pretty_value) do
          v = bindings[:view]
          [value].flatten.select(&:present?).map do |associated|
            amc = polymorphic? ? RailsAdmin::Config.model(associated) : associated_model_config # perf optimization for non-polymorphic associations
            am = amc.abstract_model
            wording = associated.send(amc.object_label_method)
            can_see = v.authorized?(:show, am, associated)
            can_see ? v.link_to(wording, v.show_path(:model_name => am.to_param, :id => associated.id)) : wording
          end.to_sentence.html_safe
        end

        register_instance_option(:sortable) do
          false
        end

        register_instance_option(:searchable) do
          false
        end

        # Accessor whether association is visible or not. By default
        # association checks whether the child model is excluded in
        # configuration or not.
        register_instance_option(:visible?) do
          @visible ||= !self.associated_model_config.excluded?
        end

        # use the association name as a key, not the association key anymore!
        register_instance_option(:label) do
          @label ||= abstract_model.model.human_attribute_name association[:name]
        end
        
        # scope for possible associable records
        register_instance_option :associated_collection_scope do
          # bindings[:object] & bindings[:controller] available
          nil
        end

        # preload entire associated collection (per associated_collection_scope) on load
        # Be sure to set limit in associated_collection_scope if set is large
        register_instance_option :associated_collection_cache_all do
          false
        end
        
        # Reader for the association's child model's configuration
        def associated_model_config
          @associated_model_config ||= RailsAdmin.config(association[:child_model])
        end

        # Reader for the association's child model object's label method
        def associated_label_method
          @associated_label_method ||= associated_model_config.object_label_method
        end

        # Reader for the association's child key
        def child_key
          association[:child_key]
        end

        # Reader for the inverse relationship
        def inverse_of
          association[:inverse_of]
        end

        # Reader for validation errors of the bound object
        def errors
          bindings[:object].errors[child_key]
        end

        # Reader whether this is a polymorphic association
        def polymorphic?
          association[:polymorphic]
        end

        # Reader for the association's value unformatted
        def value
          bindings[:object].send(association[:name])
        end
      end
    end
  end
end
