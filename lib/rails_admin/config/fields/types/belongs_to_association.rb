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
            if !associated_model_config.is_a?(Array) && associated_model_config.search.visible_fields.map(&:name).include?(associated_model_config.object_label_method)
              instance_variable_set("@sortable", "#{associated_model_config.abstract_model.model.table_name}.#{associated_model_config.object_label_method}")
            end
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
          
          register_instance_option(:sort_with) do
            associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? associated_model_config.object_label_method : :self
          end
          
          register_instance_option(:search_with) do
            associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? associated_model_config.object_label_method : nil
          end
          
          register_instance_option(:partial) do
            :form_filtering_select
          end

          register_instance_option(:render) do
            bindings[:view].render :partial => partial.to_s, :locals => {:field => self, :form => bindings[:form] }
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
