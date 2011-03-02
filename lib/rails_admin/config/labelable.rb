module RailsAdmin
  module Config
    # Defines a generic label/name/title configuration
    module Labelable
      # Try to find a user-friendly label for an object, falling back
      # to its class and ID.
      def self.object_label(object)
        if method = self.object_label_method(object)
          object.send method
        else
          "#{object.class.to_s} ##{object.try :id}"
        end
      end

      def self.object_label_method(object)
        Config.label_methods.find {|method| object.respond_to? method }
      end

      def self.included(klass)
        klass.register_instance_option(:label) do
          abstract_model.model.model_name.human(:default => abstract_model.model.model_name.titleize)
        end
        klass.register_instance_option(:object_label) {Labelable.object_label bindings[:object]}
        klass.register_instance_option(:object_label_method) {Labelable.object_label_method bindings[:object]}
      end
    end
  end
end
