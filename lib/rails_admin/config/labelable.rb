module RailsAdmin
  module Config
    # Defines a generic label/name/title configuration
    module Labelable
      def self.included(klass)
        klass.register_instance_option(:label) do
          abstract_model.model.model_name.human
        end
        klass.register_instance_option(:object_label) do
          if bindings[:object].respond_to?(:name) && bindings[:object].name
            bindings[:object].name
          elsif bindings[:object].respond_to?(:title) && bindings[:object].title
            bindings[:object].title
          else
            "#{bindings[:object].class.to_s} ##{bindings[:object].id}"
          end
        end
      end
    end
  end
end