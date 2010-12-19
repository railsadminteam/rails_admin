require 'rails_admin/config'
require 'rails_admin/config/base'
require 'rails_admin/config/sections'

module RailsAdmin
  module Config
    # Model specific configuration object.
    class Model < RailsAdmin::Config::Base
      include RailsAdmin::Config::Sections

      def initialize(abstract_model)
        @abstract_model = abstract_model
        @bindings = {}
        @parent = nil
        @root = self
        extend RailsAdmin::Config::Sections
      end

      def excluded?
        @excluded ||= !RailsAdmin::Config.excluded_models.find {|klass| klass.to_s == abstract_model.model.name }.nil?
      end

      # Bind variables to be used by the configuration options
      def bind(key, value = nil)
        if key.kind_of?(Hash)
          @bindings << key
        else
          @bindings[key] = value
        end
        self
      end

      # Configure create and update views as a bulk operation with given block
      # or get update view's configuration if no block is given
      def edit(&block)
        return @sections[:update] unless block_given?
        [:create, :update].each do |s|
          @sections[s].instance_eval &block
        end
      end

      # Act as a proxy for the section configurations that actually
      # store the configurations.
      def method_missing(m, *args, &block)
        responded_to = false
        @sections.each do |key, s|
          if s.respond_to?(m)
            responded_to = true
            s.send(m, *args, &block)
          end
        end
        raise NoMethodError.new("#{self} has no method #{m}") unless responded_to
      end
    end
  end
end
