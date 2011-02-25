require 'rails_admin/config'
require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      class Association < RailsAdmin::Config::Fields::Base

        def self.inherited(klass)
            klass.instance_variable_set("@searchable", false)
            klass.instance_variable_set("@sortable", false)
            super(klass)
        end

        # Reader for the association information hash
        def association
          @properties
        end

        # Accessor whether association is visible or not. By default
        # association checks whether the child model is excluded in
        # configuration or not.
        register_instance_option(:visible?) do
          !associated_model_config.excluded?
        end

        # Reader for a collection of association's child models in an array of
        # [label, id] arrays.
        def associated_collection
          associated_model_config.abstract_model.all.map do |object|
            [associated_model_config.list.with(:object => object).object_label, object.id]
          end
        end

        # Reader for the association's child model's configuration
        def associated_model_config
          @associated_model_config ||= RailsAdmin.config(association[:child_model])
        end

        # Reader for the association's child key
        def child_key
          association[:child_key].first
        end

        # Reader for the association's child key array
        def child_keys
          association[:child_key]
        end

        # Reader for validation errors of the bound object
        def errors
          bindings[:object].errors[child_key]
        end

        # Reader whether the bound object has validation errors
        def has_errors?
          !(bindings[:object].errors[child_key].nil? || bindings[:object].errors[child_key].empty?)
        end

        # Reader for the association's value unformatted
        def value
          bindings[:object].send(association[:name])
        end
      end
    end
  end
end
