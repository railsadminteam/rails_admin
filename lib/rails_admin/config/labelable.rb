module RailsAdmin
  module Config
    # Defines a generic label/name/title configuration
    module Labelable
      # Try to find a user-friendly label for an object, falling back
      # to its class and ID.
      def self.object_label(object)
        Config.label_methods.each {|l| label = (object.respond_to? l and object.send l) and return label}
        "#{object.class.to_s} ##{object.try :id}"
      end

      def self.included(klass)
        klass.register_instance_option(:label) do
          abstract_model.model.model_name.human(:default => abstract_model.model.model_name.titleize)
        end
        klass.register_instance_option(:object_label) {Labelable.object_label bindings[:object]}
      end
    end
  end
end
