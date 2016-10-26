require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasManyAssociation < RailsAdmin::Config::Fields::Association
          RailsAdmin::Config::Fields::Types.register(self)
          register_instance_option :partial do
            nested_form ? :form_nested_many : :form_filtering_multiselect
          end

          register_instance_option :orderable do
            false
          end

          register_instance_option :inline_add do
            true
          end

          register_instance_option :multi_select do
            bindings[:object].respond_to?(:multi_select) ? bindings[:object].send(:multi_select) : false
          end

          register_instance_option :check_boxes do
            bindings[:object].respond_to?(:check_boxes) ? bindings[:object].send(:check_boxes) : false
          end

          def method_name
            nested_form ? "#{super}_attributes".to_sym : "#{super.to_s.singularize}_ids".to_sym # name_ids
          end

          # Reader for validation errors of the bound object
          def errors
            bindings[:object].errors[name]
          end
        end
      end
    end
  end
end
