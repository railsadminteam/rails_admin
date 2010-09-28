module RailsAdmin

  # @see RailsAdmin::Config.load
  def self.config(entity, &block)
    RailsAdmin::Config.load(entity, block)
  end
  
  module Config
    
    # Stores model specific configurations in a hash identified by model's class
    # name. 
    #
    # Each value is a hash that contains a RailsAdmin::Config::Model object identified 
    # by :builder and an array of configuration blocks identified by :blocks.
    #
    # The builder object acts as a base for the configuration DSL, while blocks are
    # user defined calls against that DSL.
    #
    # @see RailsAdmin::Config.load
    @@registry = {}
    
    # Loads a model configuration from the registry or registers a new one if one
    # is yet to be added.
    #
    # If block is given it is appended to an array of model specific configuration
    # blocks in the registry.
    #
    # If no block is given the requested model's configuration will be initialized
    # with the stored configuration blocks.
    #
    # @see RailsAdmin::Config.registry
    def self.load(entity, block)
      if entity.is_a?(RailsAdmin::AbstractModel)
        entity = entity.model
      else         
        entity = entity.to_s.camelize.constantize if not entity.is_a?(Class)
      end

      config = @@registry[entity.name] ||= {
        :builder => RailsAdmin::Config::Model.new(entity),
        :blocks => [],
      }

      if block
        config[:blocks] << block
      else
        config[:blocks].reject! do |block|
          config[:builder].instance_eval &block
        end
      end
      
      config[:builder]
    end

    # Provides a DSL for configuring item's label.
    module HasLabel
      
      # Define a shortcut method for a given class.
      #
      # Eg. "HasLabel.define_helper_methods(SomeClass, :navigation)" will provide 
      # "SomeClass" with method:
      #
      #   "label_for_navigation" as proxy for "navigation.label".
      #
      # @see RailsAdmin::Config::Navigation.included
      def self.define_helper_methods(klass, name)
        klass.send(:define_method, "label_for_#{name}".to_sym) do |label = false, &block|
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
      def label(label = false, &block)
        if label || block
          @label = label || block
        else
          if @label.nil?
            label = config.nil? ? abstract_model.pretty_name : config.label
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
      # Eg. "HasVisibility.define_helper_methods(SomeClass, :navigation)" will provide 
      # "SomeClass" with methods:
      #
      #   "hidden_in_navigation?" as proxy for "navigation.hidden?"
      #   "hide_in_navigation" as proxy for "navigation.hide"
      #   "show_in_navigation" as proxy for "navigation.show"
      #   "visible_in_navigation?" as proxy for "navigation.visible?"
      #
      # @see RailsAdmin::Config::Navigation.included
      def self.define_helper_methods(klass, name)
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
      # If block is passed it will be stored to "@visible" for lazy 
      # evaluation in a lambda that will return inverse of the block. 
      # Otherwise set "@visible" to "false".
      #
      # @see RailsAdmin::Config::HasVisibility.show
      def hide(&block)
        if block
          @visible = lambda { not instance_eval &block }
        else
          @visible = false
        end
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
          visible = config.nil? ? true : config.visible?
        else
          visible = @visible
        end
        
        visible = instance_eval &visible if visible.kind_of?(Proc)
        visible
      end
    end
    
    # Base class for all model config DSL classes
    class Dsl
      # @see RailsAdmin::AbstractModel
      attr_reader :abstract_model
      # @see RailsAdmin::Config::Model
      attr_reader :config
      # @see ActiveRecord::Base
      attr_reader :model
      
      def initialize(options = {})
        @abstract_model = options[:abstract_model]
        @config = options[:config]
        @model = @abstract_model.model
        
        options[:blocks].each { |b| instance_eval &b }
      end
      
      protected
      
    end

    # Provides DSL for configuring RailsAdmin navigation
    module Navigation
      
      @@max_visible_tabs = 5
      mattr_accessor :max_visible_tabs
      
      # Register the navigation config DSL on mixin
      def self.included(klass)
        HasLabel.define_helper_methods(klass, :navigation)          
        HasVisibility.define_helper_methods(klass, :navigation)
        
        klass.define_builder_method(:navigation, NavigationDsl)
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
      # Examples:
      #
      #   RailsAdmin.config SomeModel do
      #     navigation do
      #       hide
      #       label "Tab for SomeModel"
      #     end
      #   end
      #
      #   RailsAdmin.config SomeModel do
      #     hide_in_navigation
      #     label_for_navigation "Tab for SomeModel"
      #   end
      #
      #   RailsAdmin.config SomeModel do
      #     hide_in_navigation do
      #       model.all.size == 0  
      #     end
      #     label_for_navigation do 
      #       "Tab for #{abstract_model.pretty_name}”
      #     end
      #   end
      #
      # Defaults:
      # 
      #   visible in navigation
      #   label is @abstract_model.pretty_name
      #
      # @see RailsAdmin::Config::HasLabel
      # @see RailsAdmin::Config::HasVisibility
      class NavigationDsl < RailsAdmin::Config::Dsl
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
        HasVisibility.define_helper_methods(klass, :history)
        HasLabel.define_helper_methods(klass, :history)          
        
        klass.define_builder_method(:history, Dsl)
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
      # Examples:
      #
      #   RailsAdmin.config SomeModel do
      #     history do
      #       hide
      #       label "History for SomeModel"
      #     end
      #   end
      #
      #   RailsAdmin.config SomeModel do
      #     hide_in_history
      #     label_for_history "History for SomeModel"
      #   end
      #
      #   RailsAdmin.config SomeModel do
      #     hide_in_history do
      #       model.all.size == 0  
      #     end
      #     label_for_history do 
      #       "History for #{abstract_model.pretty_name}”
      #     end
      #   end
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
        HasVisibility.define_helper_methods(klass, :list)
        HasLabel.define_helper_methods(klass, :list)          
        
        klass.define_builder_method(:list, Dsl)
      end

      # Provides DSL for configuring model specific RailsAdmin list view
      # settings.
      #
      # Examples:
      #
      #   RailsAdmin.config SomeModel do
      #     list do
      #       hide
      #       label "List for SomeModel"
      #     end
      #   end
      #
      #   RailsAdmin.config SomeModel do
      #     hide_in_list
      #     label_for_list "List for SomeModel"
      #   end
      #
      #   RailsAdmin.config SomeModel do
      #     hide_in_list do
      #       model.all.size == 0  
      #     end
      #     label_for_list do 
      #       "List for #{abstract_model.pretty_name}”
      #     end
      #   end
      #
      # Defaults:
      # 
      #   visible in list
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
    # Provides DSL for configuring RailsAdmin edit view    
    module Edit
      
      # Register the edit view config DSL on mixin
      def self.included(klass)
        HasVisibility.define_helper_methods(klass, :edit)
        HasLabel.define_helper_methods(klass, :edit)
        
        klass.define_builder_method(:edit, Dsl, false)
      end

      # Provides DSL for configuring model specific RailsAdmin edit view
      # settings.
      #
      # Examples:
      #
      #   RailsAdmin.config SomeModel do
      #     edit do
      #       hide do
      #         record.user_id != user_id
      #       end
      #       label do 
      #         record.username
      #       end
      #     end
      #   end
      #
      #   or more verbose:
      #
      #   RailsAdmin.config SomeModel do
      #     hide_in_edit do
      #       record.user_id != user_id
      #     end
      #     label_for_edit do 
      #       record.username
      #     end
      #   end
      #
      #
      # Defaults:
      # 
      #   visible in edit
      #   label is @abstract_model.pretty_name
      #
      # @see RailsAdmin::Config::HasLabel
      # @see RailsAdmin::Config::HasVisibility
      class Dsl < RailsAdmin::Config::Dsl
        include HasLabel
        include HasVisibility        
  
        attr_reader :fields
        attr_reader :record
              
        def initialize(options = {})
          @fields = ActiveSupport::OrderedHash.new          
          @record = options[:record]          
          
          super(options)
        end
      
        # Todo: Add field configurations
        # def property(name)
        #   @abstract_model.properties.find { |p| p.name == name }          
        # end
        #
        # def field(name, options = {})
        #  prop = property(name)          
        #  
        #  options[:type] ||= prop[:type]
        #  options[:label] ||= prop[:pretty_name]
        #  
        #  @fields[name.to_sym] << options
        # end
      end
    end
    
    # The base class for model config DSL extensions
    class Model
      
      # Defines a new method by the provided name which will act as proxy for
      # DSL extension class which is provided as the second argument. Optional
      # third argument defines whether proxy should reconfigure responder
      # each time it's called. This is useful for configs that depend
      # on arguments that may change per call eg. the edit configuration which
      # receives the queried record in the options hash.
      def self.define_builder_method(name, klass, static = true)
        name = name.to_sym        
        self.send(:define_method, name) do |options = {}, &block|
          registry = @registry[name] ||= { :blocks => [], :class => klass, :static => static }
          if block
            registry[:blocks] << block
          else
            call_builder(name, options)
          end
        end
      end
      
      include HasLabel
      include HasVisibility
      include Navigation
      include History
      include Edit
      include List

      attr_accessor :abstract_model
      attr_accessor :model
      
      def initialize(model)
        @abstract_model = RailsAdmin::AbstractModel.new(model)        
        @label = @abstract_model.pretty_name
        @model = @abstract_model.model
        @registry = {}
        @visible = true
      end

      protected

      # Calls a DSL extension of a given name.
      #
      # If the extension is defined as static it is only configured once.
      # Otherwise it will be reloaded on each query which allows dynamic
      # parameters where required and caching for other extensions.
      #
      # @see RailsAdmin::Config::Model.registry
      def call_builder(name, options = {})
        config = @registry[name]

        options[:abstract_model] = @abstract_model
        options[:blocks] = config[:blocks]
        options[:config] = self

        obj = config[:static] && config[:builder] ||= config[:class].new(options)            
      end      
    end
  end
end