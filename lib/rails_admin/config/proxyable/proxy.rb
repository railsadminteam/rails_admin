

module RailsAdmin
  module Config
    module Proxyable
      class Proxy < BasicObject
        def initialize(object, bindings = {})
          @object = object
          @bindings = bindings
        end

        # Bind variables to be used by the configuration options
        def bind(key, value = nil)
          if key.is_a?(::Hash)
            @bindings = key
          else
            @bindings[key] = value
          end
          self
        end

        def method_missing(method_name, *args, &block)
          if @object.respond_to?(method_name)
            reset = @object.bindings
            begin
              @object.bindings = @bindings
              response = @object.__send__(method_name, *args, &block)
            ensure
              @object.bindings = reset
            end
            response
          else
            super(method_name, *args, &block)
          end
        end
      end
    end
  end
end
