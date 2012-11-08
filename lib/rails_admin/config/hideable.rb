module RailsAdmin
  module Config
    # Defines a visibility configuration
    module Hideable
      # Visibility defaults to true.
      def self.included(klass)
        klass.register_instance_option :visible? do
          !root.try :excluded?
        end
      end

      # Reader whether object is hidden.
      def hidden?
        not visible
      end

      # Writer to hide object.
      def hide(&block)
        visible block ? proc { false == (instance_eval &block) } : false
      end

      # Writer to show field.
      def show(&block)
        visible block || true
      end
    end
  end
end
