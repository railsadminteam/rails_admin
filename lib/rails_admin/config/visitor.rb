module RailsAdmin
  module Config
    class Visitor

      instance_methods.each { |m| undef_method m unless m =~ /^__/ || m == "object_id" }

      attr_reader :bindings

      def initialize(object, bindings = {})
        @object = object
        @bindings = bindings
      end

      # Bind variables to be used by the configuration options
      def bind(key, value = nil)
        if key.kind_of?(Hash)
          @bindings = key
        else
          @bindings[key] = value
        end
        self
      end

      def method_missing(name, *args, &block)
        if @object.has_option?(name) || @object.respond_to?(name)
          object_bindings = @object.bindings
          @object.bind(bindings)
          response = @object.__send__(name, *args, &block)
          @object.bind(object_bindings)
          response
        else
          super(name, *args, &block)
        end
      end
    end
  end
end