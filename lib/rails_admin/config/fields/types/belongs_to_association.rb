require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BelongsToAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          attr_reader :association

          def initialize(parent, name, properties, association)
            super(parent, name, properties)
            @association = association
          end

          # Accessor for field's formatted value
          register_instance_option(:formatted_value) do
            object = bindings[:object].send(association[:name])
            unless object.nil?
              RailsAdmin::Config.model(object).list.with(:object => object).object_label
            else
              nil
            end
          end

          register_instance_option(:partial) do
            :form_belongs_to
          end

          def associated_collection
            objects = associated_model_config.abstract_model.all
            label_method = associated_model_config.list.with(:object => objects.first).object_label_method unless objects.empty?
            objects.map do |object|
              [object.send(label_method), object.id]
            end
          end

          def associated_model_config
            @associated_model_config ||= RailsAdmin.config(association[:parent_model])
          end

          # Reader for field's value
          def value
            bindings[:object].send(name)
          end
        end
      end
    end
  end
end
