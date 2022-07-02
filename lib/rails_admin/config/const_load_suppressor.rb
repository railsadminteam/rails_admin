# frozen_string_literal: true

module RailsAdmin
  module Config
    module ConstLoadSuppressor
      def suppress_const_load
        original = Object.method(:const_missing)
        Object.define_singleton_method(:const_missing) do |name|
          ConstProxy.new(name.to_s)
        end
        yield
      ensure
        Object.define_singleton_method(:const_missing, original)
      end

      class ConstProxy < BasicObject
        attr_reader :name

        def initialize(name)
          @name = name
        end

        def klass
          @klass ||=
            begin
              unless ::Object.const_defined?(name)
                ::Kernel.raise <<~MESSAGE
                  The constant #{name} is not loaded yet upon the execution of the RailsAdmin initializer.
                  We don't recommend to do this and may lead to issues, but if you really have to do so you can explicitly require it by adding:

                    require '#{name.underscore}'

                  on top of config/initializers/rails_admin.rb.
                MESSAGE
              end
              name.constantize
            end
        end

        def method_missing(method_name, *args, &block)
          klass.send(method_name, *args, &block)
        end

        def respond_to_missing?(method_name, include_private = false)
          super || klass.respond_to?(method_name, include_private)
        end
      end
    end
  end
end
