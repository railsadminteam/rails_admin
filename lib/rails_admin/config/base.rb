require 'rails_admin/config/proxy'

module RailsAdmin
  module Config
    # A base class for all configurables.
    #
    # Each configurable has a parent object. This parent object must provide
    # the configurable with abstract_model and bindings.
    #
    # Bindings is a hash of variables bound by the querying context. For
    # example the list view's template will bind an object to key
    # :object for each row it outputs. This object is the actual row object
    # which is then used as the receiver of queries for property values.
    #
    # @see RailsAdmin::AbstractModel
    # @see RailsAdmin::Config::Model#abstract_model
    class Base
      attr_reader :abstract_model, :bindings, :parent, :root

      def initialize(parent)
        @abstract_model = parent.abstract_model
        @bindings = {}
        @parent = parent
        @root = parent.root
      end

      def has_option?(name)
        options = self.class.instance_variable_get("@config_options")
        options && options.has_key?(name)
      end

      # Register an instance option for this object only
      def register_instance_option(option_name, &default)
        scope = class << self; self; end;
        self.class.register_instance_option(option_name, scope, &default)
      end

      def with(bindings = {})
        RailsAdmin::Config::Proxy.new(self, bindings)
      end

      # Register an instance option. Instance option is a configuration
      # option that stores it's value within an instance variable and is
      # accessed by an instance method. Both go by the name of the option.
      def self.register_instance_option(option_name, scope = self, &default)
        unless options = scope.instance_variable_get("@config_options")
          options = scope.instance_variable_set("@config_options", {})
        end

        option_name = option_name.to_s

        options[option_name] = nil

        # If it's a boolean create an alias for it and remove question mark
        if "?" == option_name[-1, 1]
          scope.send(:define_method, "#{option_name.chop!}?") do
            send(option_name)
          end
        end

        # Define getter/setter by the option name
        scope.send(:define_method, option_name) do |*args, &block|
          if !args[0].nil? || block
            instance_variable_set("@#{option_name}", args[0].nil? ? block : args[0])
          else
            value = instance_variable_get("@#{option_name}")
            value = default if value.nil?
            if value.kind_of?(Proc)
              # Override current method with the block containing this option's default value.
              # This prevents accidental infinite loops and allows configurations such as
              # label { "#{label}".upcase }
              option_method = scope.instance_method(option_name)
              scope.send(:define_method, option_name, default)
              value = instance_eval &value
              scope.send(:define_method, option_name, option_method) # Return the original method
            end
            value
          end
        end
      end

      # Register a class option. Class option is a configuration
      # option that stores it's value within a class object's instance variable
      # and is accessed by a class method. Both go by the name of the option.
      def self.register_class_option(option_name, &default)
        scope = class << self; self; end;
        self.register_instance_option(option_name, scope, &default)
      end
    end
  end
end