

require 'rails_admin/config/proxyable/proxy'
module RailsAdmin
  module Config
    module Proxyable
      def bindings
        Thread.current[:rails_admin_bindings] ||= {}
        Thread.current[:rails_admin_bindings][self]
      end

      def bindings=(new_bindings)
        Thread.current[:rails_admin_bindings] ||= {}
        if new_bindings.nil?
          Thread.current[:rails_admin_bindings].delete(self)
        else
          Thread.current[:rails_admin_bindings][self] = new_bindings
        end
      end

      def with(bindings = {})
        RailsAdmin::Config::Proxyable::Proxy.new(self, bindings)
      end
    end
  end
end
