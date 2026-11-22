# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/fields'
require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        @@registry = {}
        @@deprecations = {}

        def self.load(type)
          type = type.to_sym
          klass = @@registry.fetch(type) { raise "Unsupported field datatype: #{type}" }
          if (advice = @@deprecations[type])
            RailsAdmin.deprecator.warn("The :#{type} field type is deprecated, #{advice}.")
          end
          klass
        end

        def self.register(type, klass = nil)
          type, klass = name_and_class(type, klass)
          @@registry[type] = klass
        end

        # Registers a field type which is deprecated, either in favour of a replacement
        # field type or because the editor it loads is no longer maintained.
        def self.register_deprecated(type, klass = nil, replacement: nil, reason: nil)
          raise ArgumentError.new('register_deprecated takes either a replacement: or a reason:') unless replacement.nil? ^ reason.nil?

          type, klass = name_and_class(type, klass)
          @@deprecations[type] = replacement ? "please use :#{replacement} instead" : "because #{reason}"
          @@registry[type] = klass
        end

        def self.name_and_class(type, klass)
          if klass.nil? && type.is_a?(Class)
            klass = type
            type = klass.name.to_s.demodulize.underscore
          end
          [type.to_sym, klass]
        end
        private_class_method :name_and_class

        require 'rails_admin/config/fields/types/all'
      end
    end
  end
end
