require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasOneAssociation < RailsAdmin::Config::Fields::Association
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          
          register_instance_option :partial do
            nested_form ? :form_nested_one : :form_filtering_select
          end

          # Accessor for field's formatted value
          register_instance_option(:formatted_value) do
            (o = value) && o.send(associated_model_config.object_label_method)
          end
          
          def editable
            (nested_form || abstract_model.model.new.respond_to?("#{self.name}_id=")) && super
          end
          
          def selected_id
            value.try :id
          end
          
          def method_name
            nested_form ? "#{self.name}_attributes" : "#{self.name}_id"
          end
        end
      end
    end
  end
end
