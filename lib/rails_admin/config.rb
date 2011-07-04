require 'rails_admin/config/model'
require 'rails_admin/config/sections/list'
require 'rails_admin/config/sections/navigation'
require 'active_support/core_ext/class/attribute_accessors'

module RailsAdmin
  module Config
    # Stores model configuration objects in a hash identified by model's class
    # name.
    #
    # @see RailsAdmin::Config.model
    @@registry = {}

    # Configuration option to specify which models you want to exclude.
    @@excluded_models = []
    mattr_accessor :excluded_models

    # Configuration option to specify a whitelist of models you want to RailsAdmin to work with.
    # The excluded_models list applies against the whitelist as well and further reduces the models
    # RailsAdmin will use.
    # If included_models is left empty ([]), then RailsAdmin will automatically use all the models
    # in your application (less any excluded_models you may have specified).
    @@included_models = []
    mattr_accessor :included_models

    @@default_search_operator = 'default'
    def self.default_search_operator=(operator)
      if %w{ default like starts_with ends_with is = }.include? operator
        @@default_search_operator = operator
      else
        raise ArgumentError, "Search operator '#{operator}' not supported"
      end
    end
    mattr_reader :default_search_operator

    # Configuration option to specify which method names will be searched for
    # to be used as a label for object records. This defaults to [:name, :title]
    mattr_accessor :label_methods
    self.label_methods = [:name, :title]

    # Shortcut to access the list section's class configuration
    # within a config DSL block
    #
    # @see RailsAdmin::Config::Sections::List
    def self.list
      RailsAdmin::Config::Sections::List
    end

    # Loads a model configuration instance from the registry or registers
    # a new one if one is yet to be added.
    #
    # First argument can be an instance of requested model, it's class object,
    # it's class name as a string or symbol or a RailsAdmin::AbstractModel
    # instance.
    #
    # If a block is given it is evaluated in the context of configuration instance.
    #
    # Returns given model's configuration
    #
    # @see RailsAdmin::Config.registry
    def self.model(entity, &block)
      key = begin
        if entity.kind_of?(RailsAdmin::AbstractModel)
          entity.model.name.to_sym
        elsif entity.kind_of?(Class)
          entity.name.to_sym
        elsif entity.kind_of?(String) || entity.kind_of?(Symbol)
          entity.to_sym
        else
          entity.class.name.to_sym
        end
      end
      config = @@registry[key] ||= RailsAdmin::Config::Model.new(entity)
      config.instance_eval(&block) if block
      config
    end

    # Returns all model configurations
    #
    # If a block is given it is evaluated in the context of configuration
    # instances.
    #
    # @see RailsAdmin::Config.registry
    def self.models(&block)
      RailsAdmin::AbstractModel.all.map{|m| model(m, &block)}
    end

    # Shortcut to access the navigation section's class configuration
    # within a config DSL block
    #
    # @see RailsAdmin::Config::Sections::Navigation
    def self.navigation
      RailsAdmin::Config::Sections::Navigation
    end

    # Reset a provided model's configuration. If omitted, reset all model
    # configurations.
    #
    # @see RailsAdmin::Config.registry
    def self.reset(model = nil)
      if model.kind_of?(Class) || model.kind_of?(String) || model.kind_of?(Symbol)
        key = model.kind_of?(Class) ? model.name.to_sym : model.to_sym
        @@registry.delete(key)
      else
        @@registry.clear
      end
    end

    # Get all models that are configured as visible sorted by their weight and label.
    #
    # @see RailsAdmin::Config::Hideable
    def self.visible_models
      RailsAdmin::Config.models.select {|m| m.visible? }.sort do |a, b|
        (weight_order = a.weight <=> b.weight) == 0 ? a.label.downcase <=> b.label.downcase : weight_order
      end
    end
  end
end
