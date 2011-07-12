require 'rails_admin/config'
require 'rails_admin/config/base'
require 'rails_admin/config/sections'

module RailsAdmin
  module Config
    # Model specific configuration object.
    class Model < RailsAdmin::Config::Base
      include RailsAdmin::Config::Hideable
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
        return @excluded unless @excluded.nil?
        @excluded = !RailsAdmin::AbstractModel.all.map(&:model).include?(abstract_model.model)
      end

      # Configure create and update views as a bulk operation with given block
      # or get update view's configuration if no block is given
      def edit(&block)
        return send(:update) unless block_given?
        [:create, :update].each do |s|
          send(s, &block)
        end
      end

      def object_label
        bindings[:object].send object_label_method
      end

      # The display for a model instance (i.e. a single database record).
      # Unless configured in a model config block, it'll try to use :name followed by :title methods, then
      # any methods that may have been added to the label_methods array via Configuration.
      # Failing all of these, it'll return the class name followed by the model's id.
      register_instance_option(:object_label_method) do
        @object_label_method ||= Config.label_methods.find { |method| abstract_model.model.new.respond_to? method } || :rails_admin_default_object_label_method
      end

      register_instance_option(:label) do
        abstract_model.model.model_name.human(:default => abstract_model.model.model_name.titleize)
      end

      register_instance_option(:weight) do
        0
      end

      register_instance_option(:parent) do
        :root
      end

      register_instance_option(:dropdown) do
        false
      end

      # Act as a proxy for the section configurations that actually
      # store the configurations.
      def method_missing(m, *args, &block)
        responded_to = false
        [:create, :list, :show, :navigation, :update].each do |s|
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
