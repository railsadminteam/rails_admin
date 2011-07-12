require 'rails_admin/config/fields/types/belongs_to_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class PolymorphicAssociation < RailsAdmin::Config::Fields::Types::BelongsToAssociation
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @column_width = 250

          def initialize(parent, name, properties, association)
            super(parent, name, properties, association)
          end

          register_instance_option(:edit_partial) do
            :form_polymorphic_association
          end

          register_instance_option(:show_partial) do
            :show_polymorphic_association
          end

          # Accessor whether association is visible or not. By default
          # association checks that any of the child models are included in
          # configuration.
          register_instance_option(:visible?) do
            associated_model_config.length > 0
          end

          register_instance_option(:sortable) do
            false
          end

          register_instance_option(:searchable) do
            false
          end

          def associated_collection(type)
            return [] if type.nil?
            config = RailsAdmin.config(type)
            config.abstract_model.all.map do |object|
              [object.send(config.object_label_method), object.id]
            end
          end

          def associated_model_config
            association[:parent_model].map{|type| RailsAdmin.config(type) }.select{|config| !config.excluded? }
          end

          def polymorphic_type_collection
            associated_model_config.map do |config|
              [config.label, config.abstract_model.model.name]
            end
          end

          def polymorphic_type_urls
            types = associated_model_config.map do |config|
              [config.abstract_model.model.name, config.abstract_model.to_param]
            end

            Hash[*types.collect { |v|
                  [v[0], bindings[:view].rails_admin_list_path(v[1])]
                }.flatten]
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
