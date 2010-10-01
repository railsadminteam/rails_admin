module RailsAdmin

  module Config
    
    # Stores model specific configuration objects in a hash identified by model's class
    # name. 
    #
    # @see RailsAdmin::Config.load
    @@registry = {}

    # Configuration option to specify which models you want to exclude. 
    @@excluded_models = []
    mattr_accessor :excluded_models
    
    # Loads given model's configuration instance from the registry or registers 
    # a new one if one is yet to be added.
    #
    # If a block is given it is evaluated in the context of configuration instance.
    #
    # Returns given model's configuration.
    #
    # @see RailsAdmin::Config.registry
    def self.load(entity, block = nil)
      if entity.is_a?(RailsAdmin::AbstractModel)
        entity = entity.model
      else         
        entity = entity.to_s.camelize.constantize if not entity.is_a?(Class)
      end

      config = @@registry[entity.name] ||= RailsAdmin::Config::Model.new(entity)
      config.instance_eval &block if block
      
      config
    end

    # Reset a model's configuration.
    #
    # @see RailsAdmin::Config.load
    def self.reset(entity)
      # Todo: Refactor duplicate code with self.load 
      if entity.is_a?(RailsAdmin::AbstractModel)
        entity = entity.model
      else         
        entity = entity.to_s.camelize.constantize if not entity.is_a?(Class)
      end
      @@registry[entity.name] = nil
    end

    # Provides a DSL for configuring item's label.
    module HasLabel
      
      # Define a shortcut method for a given class.
      #
      # Eg. "HasLabel.shortcuts_for(SomeClass, :navigation)" will provide 
      # "SomeClass" with method:
      #
      #   "label_for_navigation" as proxy for "navigation.label".
      #
      # @see RailsAdmin::Config::Navigation.included
      def self.shortcuts_for(klass, name)
        klass.send(:define_method, "label_for_#{name}".to_sym) do |*args, &block|
          # Support for default arguments in ruby 1.8 via splat
          label = args[0] || nil
          send(name).label(label, &block)
        end
      end
      
      # Get or set a label.
      #
      # If first argument is provided "@label" is set to that value. 
      # Optionally first argument can be omitted and a block passed. 
      # In this case the block will be stored to the same variable for lazy 
      # evaluation.
      #
      # If no arguments are passed it will return first of following:
      #
      #   1. "@label" evaluated in object context if it's a Proc.
      #   2. "@label" if it is set.
      #   3. Result of calling parent object's "label" method if parent object
      #      is set.
      #   4. "abstract_model.pretty_name"
      def label(label = nil, &block)
        if label || block
          @label = label || block
        else
          if @label.nil?
            label = parent.nil? ? parent.abstract_model.pretty_name : parent.label
          else
            label = @label
          end
          label = instance_eval &label if label.kind_of?(Proc)
          label
        end
      end
    end

    # Provides a DSL for configuring item's visibility
    module HasVisibility
      
      # Define shortcut methods for a given class.
      #
      # Eg. "HasVisibility.shortcuts_for(SomeClass, :navigation)" will provide 
      # "SomeClass" with methods:
      #
      #   "hidden_in_navigation?" as proxy for "navigation.hidden?"
      #   "hide_in_navigation" as proxy for "navigation.hide"
      #   "show_in_navigation" as proxy for "navigation.show"
      #   "visible_in_navigation?" as proxy for "navigation.visible?"
      #
      # @see RailsAdmin::Config::Navigation.included
      def self.shortcuts_for(klass, name)
        klass.send(:define_method, "hidden_in_#{name}?".to_sym) do
          send(name).hidden?
        end
        
        klass.send(:define_method, "hide_in_#{name}".to_sym) do |&block|
          send(name).hide(&block)
        end
        
        klass.send(:define_method, "show_in_#{name}".to_sym) do |&block|
          send(name).show(&block)
        end
        
        klass.send(:define_method, "visible_in_#{name}?".to_sym) do
          send(name).visible?
        end
      end
      
      # Is item hidden?
      #
      # Inverse of visible?
      #
      # @see RailsAdmin::Config::HasVisibility.visible?
      def hidden?()
        not visible?()
      end

      # Make item hidden.
      #
      # @see RailsAdmin::Config::HasVisibility.show
      def hide()
        @visible = false
      end

      # Make item visible.
      #
      # If block is passed it will be stored to "@visible" for lazy 
      # evaluation. Otherwise set "@visible" to "true".
      def show(&block)
        @visible = block || true
      end

      # Is item visible?
      #
      # Will return first of following:
      #
      #   1. "@visible" evaluated in object context if it's a Proc.
      #   2. "@visible" if it is set.
      #   3. Result of calling parent object's "visible" method if parent object
      #      is set.
      #   4. "true" as last resort
      def visible?()          
        if @visible.nil?
          visible = parent.nil? ? true : parent.visible?
        else
          visible = @visible
        end
        visible = instance_eval &visible if visible.kind_of?(Proc)
        visible
      end
    end
    
    # Base class for all model config DSL classes
    class Dsl
      # @see RailsAdmin::Config::Model
      attr_reader :parent
      
      def initialize(parent)
        @parent = parent
      end
    end

    # Provides DSL for configuring RailsAdmin navigation
    module Navigation
      
      @@max_visible_tabs = 5
      mattr_accessor :max_visible_tabs
      
      # Register the navigation config DSL on mixin
      def self.included(klass)
        
        HasLabel.shortcuts_for(klass, :navigation)          
        HasVisibility.shortcuts_for(klass, :navigation)
        
        klass.send(:define_method, :navigation) do |&block|          
          extension = @registry[:navigation] ||= Dsl.new(self)
          extension.instance_eval &block if block
          extension
        end
      end
      
      # Get all models that are configured as visible 
      def self.visible_models
        RailsAdmin::AbstractModel.all.select do |m|
          RailsAdmin.config(m.model).navigation.visible?
        end
      end

      # Provides DSL for configuring model specific RailsAdmin navigation
      # settings.
      #
      # Defaults:
      # 
      #   visible in navigation
      #   label is @abstract_model.pretty_name
      #
      # @see RailsAdmin::Config::HasLabel
      # @see RailsAdmin::Config::HasVisibility
      class Dsl < RailsAdmin::Config::Dsl
        include HasLabel
        include HasVisibility
      end
    end

    # DEVELOPMENT NOTICE: Quite useless as is, just a stub for
    # further exploration...
    #
    # Provides DSL for configuring RailsAdmin history    
    module History
      
      # Register the history config DSL on mixin
      def self.included(klass)
        
        HasVisibility.shortcuts_for(klass, :history)
        HasLabel.shortcuts_for(klass, :history)          
        
        klass.send(:define_method, :history) do |&block|          
          extension = @registry[:history] ||= Dsl.new(self)
          extension.instance_eval &block if block
          extension
        end
      end

      # Get all models that are configured as visible 
      def self.visible_models
        RailsAdmin::AbstractModel.all.select do |m|
          RailsAdmin.config(m.model).history.visible?
        end
      end
      
      # Provides DSL for configuring model specific RailsAdmin history
      # settings.
      #
      # Defaults:
      # 
      #   visible in history
      #   label is @abstract_model.pretty_name
      #
      # @see RailsAdmin::Config::HasLabel
      # @see RailsAdmin::Config::HasVisibility      
      class Dsl < RailsAdmin::Config::Dsl
        include HasLabel
        include HasVisibility
      end        
    end            
    
    # DEVELOPMENT NOTICE: Quite useless as is, just a stub for
    # further exploration...
    #
    # Provides DSL for configuring RailsAdmin list view    
    module List
      
      # Register the list view config DSL on mixin
      def self.included(klass)
        
        HasVisibility.shortcuts_for(klass, :list)
        HasLabel.shortcuts_for(klass, :list)          
        
        klass.send(:define_method, :list) do |&block|          
          extension = @registry[:list] ||= Dsl.new(self)
          extension.instance_eval &block if block
          extension
        end
      end

      # Provides DSL for configuring model specific RailsAdmin list view
      # settings.
      #
      # @see RailsAdmin::Config::HasLabel
      # @see RailsAdmin::Config::HasVisibility      
      class Dsl < RailsAdmin::Config::Dsl
        include HasLabel
        include HasVisibility        
      end
    end    

    # DEVELOPMENT NOTICE: Quite useless as is, just a stub for
    # further exploration...
    #
    # Provides DSL for configuring RailsAdmin edit view    
    module Edit
      
      # Register the edit view config DSL on mixin
      def self.included(klass)
        
        HasVisibility.shortcuts_for(klass, :edit)
        HasLabel.shortcuts_for(klass, :edit)
        
        klass.send(:define_method, :edit) do |*args, &block|
          # Support for default arguments in ruby 1.8 via splat
          record = args[0] || nil          
          extension = @registry[:edit] ||= Dsl.new(self)
          extension.instance_eval &block if block
          extension.record = record
          extension
        end
      end

      # Provides DSL for configuring model specific RailsAdmin edit view
      # settings.
      #
      # @see RailsAdmin::Config::HasLabel
      # @see RailsAdmin::Config::HasVisibility      
      class Dsl < RailsAdmin::Config::Dsl
        include HasLabel
        include HasVisibility        
  
        attr_reader :fields
        attr_accessor :record
              
        def initialize(config)
          super(config)
          @fields = ActiveSupport::OrderedHash.new          
        end
      end
    end
    
    # The base class for model config DSL extensions
    class Model

      include HasLabel
      include HasVisibility
      include Navigation
      include History
      include Edit
      include List

      attr_accessor :abstract_model
      
      def initialize(model)
        @abstract_model = RailsAdmin::AbstractModel.new(model)        
        @label = @abstract_model.pretty_name
        @registry = {}
        @visible = true
      end

    end
  end
end
