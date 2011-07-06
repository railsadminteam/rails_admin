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
              RailsAdmin::Config.model(object).with(:object => object).object_label
            else
              nil
            end
          end

          register_instance_option(:sortable) do
            associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? associated_model_config.object_label_method : true
          end

          register_instance_option(:searchable) do
            associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? [associated_model_config.object_label_method, {self.abstract_model.model.name => self.name}] : true
          end

          register_instance_option(:edit_partial) do
            :form_filtering_select
          end

          def associated_model_config
            @associated_model_config ||= RailsAdmin.config(association[:parent_model])
          end

          def selected_id
            bindings[:object].send(child_key)
          end

          # Reader for field's value
          def value
            bindings[:object].send(name)
          end

          def method_name
            name.to_s
          end
        end
      end
    end
  end
end
