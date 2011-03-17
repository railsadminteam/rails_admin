require 'rails_admin/config'
require 'rails_admin/config/base'
require 'rails_admin/config/sections'

module RailsAdmin
  module Config
    # Model specific configuration object.
    class Model < RailsAdmin::Config::Base
      include RailsAdmin::Config::Sections

      def initialize(entity)
        @abstract_model = begin
          if entity.kind_of?(RailsAdmin::AbstractModel)
            entity
          elsif entity.kind_of?(Class) || entity.kind_of?(String) || entity.kind_of?(Symbol)
            RailsAdmin::AbstractModel.new(entity)
          else
            RailsAdmin::AbstractModel.new(entity.class)
          end
        end
        @bindings = {}
        @parent = nil
        @root = self
      end

      def excluded?
        @excluded ||= !RailsAdmin::Config.excluded_models.find {|klass| klass.to_s == abstract_model.model.name }.nil?
      end

      # Configure create and update views as a bulk operation with given block
      # or get update view's configuration if no block is given
      def edit(&block)
        return send(:update) unless block_given?
        [:create, :update].each do |s|
          send(s, &block)
        end
      end

      # Act as a proxy for the section configurations that actually
      # store the configurations.
      def method_missing(m, *args, &block)
        responded_to = false
        [:create, :list, :navigation, :update].each do |s|
          section = send(s)
          if section.respond_to?(m)
            responded_to = true
            section.send(m, *args, &block)
          end
        end
        raise NoMethodError.new("#{self} has no method #{m}") unless responded_to
      end
    end
  end
end
