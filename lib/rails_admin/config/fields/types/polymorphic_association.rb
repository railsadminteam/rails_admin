require 'rails_admin/config/fields/types/belongs_to_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class PolymorphicAssociation < RailsAdmin::Config::Fields::Types::BelongsToAssociation
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @column_width = 250

          # Accessor whether association is visible or not. By default
          # association checks that any of the child models are included in
          # configuration.
          register_instance_option(:visible?) do |p|
            associated_model_config.length > 0
          end

          def associated_collection
            config = associated_model_config.first
            config.abstract_model.all.map do |object|
              [config.bind(:object, object).list.object_label, object.id]
            end
          end

          def associated_model_config
            association[:parent_model].map{|type| RailsAdmin.config(type) }.select{|config| !config.excluded? }
          end

          def polymorphic_type_collection
            associated_model_config.map do |config|
              [config.list.label, config.abstract_model.model.name]
            end
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
