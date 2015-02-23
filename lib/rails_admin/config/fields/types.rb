require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/fields'
require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        @@registry = {}

        def self.load(type)
          @@registry[type.to_sym] || fail("Unsupported field datatype: #{type}")
        end

        def self.register(type, klass = nil)
          if klass.nil? && type.is_a?(Class)
            klass = type
            type = klass.name.to_s.demodulize.underscore
          end
          @@registry[type.to_sym] = klass
        end

        require 'rails_admin/config/fields/types/all'
      end
    end
  end
end
