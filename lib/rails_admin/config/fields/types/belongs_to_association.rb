require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BelongsToAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          # Accessor for field's formatted value
          register_instance_option :formatted_value do
            (o = value) && o.send(associated_model_config.object_label_method)
          end

          register_instance_option :sortable do
            @sortable ||= associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? associated_model_config.object_label_method : {self.abstract_model.model.table_name => self.method_name}
          end

          register_instance_option :searchable do
            @searchable ||= associated_model_config.abstract_model.properties.map{ |p| p[:name] }.include?(associated_model_config.object_label_method) ? [associated_model_config.object_label_method, {self.abstract_model.model => self.method_name}] : {self.abstract_model.model => self.method_name}
          end

          register_instance_option :partial do
            nested_form ? :form_nested_one : :form_filtering_select
          end

          def associated_model_config
            @config ||= RailsAdmin.config(association[:parent_model_proc].call)
          end

          def selected_id
            bindings[:object].send(child_key)
          end

          def method_name
            nested_form ? "#{association[:child_key]}_attributes" : association[:child_key]
          end
        end
      end
    end
  end
end
