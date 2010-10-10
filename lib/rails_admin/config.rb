module RailsAdmin

  module Config

    # Stores a shared model configuration object which acts as a global fallback.
    #
    # @see RailsAdmin::Config.global
    @@shared_model = nil
    
    # Stores model specific configuration objects in a hash identified by model's class
    # name. 
    #
    # @see RailsAdmin::Config.model
    @@registry = {}

    # Configuration option to specify which models you want to exclude. 
    @@excluded_models = []
    mattr_accessor :excluded_models

    # Alias for the shared fallback model configuration.
    #
    # @see RailsAdmin::Config.load
    def self.shared_model(abstract_model = nil, &block)
      config = load(nil, block)
      config.abstract_model = abstract_model
      config
    end

    # Alias for model specific configuration.
    #
    # @see RailsAdmin::Config.load
    def self.model(entity = nil, &block)
      load(entity, block)
    end
    
    # Loads given model's configuration instance from the registry or registers 
    # a new one if one is yet to be added. 
    #
    # 1st argument can be requested model's class object, class name as a string or symbol 
    # or a RailsAdmin::AbstractModel instance of the requested model. A shared fallback model 
    # configuration can be accessed by omitting the first argument.
    #
    # If a block is given it is evaluated in the context of configuration instance.
    #
    # Returns given model's configuration or the shared fallback model configuration.
    #
    # @see RailsAdmin::Config.registry
    def self.load(entity = nil, block = nil)      
      if entity.nil?
        config = @@shared_model ||= RailsAdmin::Config::SharedModel.new(self)
      else
        if entity.is_a?(RailsAdmin::AbstractModel)
          key = entity.model.name
        else
          entity = entity.to_s.camelize.constantize unless entity.is_a?(Class)
          entity = RailsAdmin::AbstractModel.new(entity)
        end
        config = @@registry[entity.model.name] ||= RailsAdmin::Config::Model.new(entity, self)
      end      
      config.instance_eval &block if block      
      config
    end
    
    # Reset a model's configuration. By omitting the first argument all model configurations
    # are reset.
    #
    # @see RailsAdmin::Config.load
    def self.reset(entity = nil)
      if entity.nil?
        @@shared_model = nil
        @@registry = {}
      else
        config = self.load(entity)
        @@registry[config.abstract_model.model.name] = nil
      end
    end

    # Alias for the navigation section configuration.
    #
    # @see RailsAdmin::Config::Sections::Navigation
    def self.navigation
      RailsAdmin::Config::Sections::Navigation
    end

    # A base for all configurables.
    class Base                
      attr_reader :parent

      def initialize(parent)
        @parent = parent
      end
      
      # The abstract model associated with the current configuration
      #
      # @see RailsAdmin::AbstractModel
      def abstract_model
        parent.abstract_model
      end

      # The model object associated with the abstract model of current configuration
      def model
        abstract_model.model
      end

      # Read a configuration value stored in an instance variable named by the argument.
      # Subclasses may override this method to implement different
      # lookup strategies - eg. such that will traverse the parent configurations
      # for fallback values.
      #
      # @see RailsAdmin::Config::Model.read_option
      def read_option(option_name, recursive = true)
        instance_variable_get("@#{option_name}")
      end      

      def self.register_option(option_name, &default)
        define_method("#{option_name}=") do |value|
          instance_variable_set("@#{option_name}", value)
        end        
        define_method(option_name) do |*args, &block|
          if !args[0].nil? || block
            instance_variable_set("@#{option_name}", args[0].nil? ? block : args[0])
          else
            value = read_option(option_name)
            value = default if value.nil?
            if value.kind_of?(Proc)
              # Override current method with the block containing this option's default value.
              # This prevents accidental infinite loops and allows configurations such as
              # label { "#{label}".upcase }
              option_method = self.class.instance_method(option_name)
              self.class.send(:define_method, option_name, default)
              value = instance_eval &value
              self.class.send(:define_method, option_name, option_method) # Return the original method
            end
            value
          end
        end
      end

      # Is this an instance or a child of the shared model configuration. This information
      # is used when finding the fallback paths while querying for option values.
      #
      # @see RailsAdmin::Config::Base.read_option
      def shared?
        false
      end
    end

    # Defines a generic label/name/title configuration
    module Labelable
      def self.included(klass)
        klass.register_option(:label) do
          abstract_model.pretty_name
        end
      end
    end
    
    # Defines a visibility configuration
    module Hideable
      def self.included(klass)
        klass.register_option(:visible) do
          true
        end
      end
      
      def hidden?
        not visible
      end

      def hide(&block)
        visible block ? proc { false == (instance_eval &block) } : false
      end

      def show(&block)
        visible block || true
      end
      
      def visible?
        visible
      end
    end
    
    # Fields describe the configuration for model's properties that RailsAdmin will
    # use when rendering the list and edit views.
    module Fields
      # Defines a configuration for a named field.
      def field(name, &block)
        @named_fields ||= []
        field = @named_fields.find { |f| name == f.name } || (@named_fields << RailsAdmin::Config::Fields::Named.new(name, self))[-1]
        field.instance_eval &block if block
        field
      end

      # Defines a configuration for a typed field.
      def field_of_type(type, name = nil, &block)
        @typed_fields ||= []
        field = @typed_fields.find { |f| type == f.type } || (@typed_fields << RailsAdmin::Config::Fields::Typed.new(type, self))[-1]
        field.instance_eval &block if block
        field.name = name
        field
      end

      # Returns all named field configurations for the model configuration instance. If no fields
      # have been defined returns all fields.
      def fields
        @named_fields ||= abstract_model.properties.map do |p| 
          RailsAdmin::Config::Fields::Named.new(p[:name], self)
        end
      end

      # A base class for configuring the fields of models.
      class Base < RailsAdmin::Config::Base
        include RailsAdmin::Config::Hideable

        register_option(:label) do
          abstract_model.properties.find { |column| name == column[:name] }[:pretty_name]
        end

        register_option(:length) do
          abstract_model.properties.find { |column| name == column[:name] }[:length]
        end

        def parent_is_section?
          parent.kind_of?(RailsAdmin::Config::Sections::Base)
        end

        register_option(:searchable) do
          type == :string
        end
        
        def searchable?
          searchable
        end

        register_option(:sortable) do
          true
        end
        
        def sortable?
          sortable
        end

        def required
          abstract_model.properties.find { |column| name == column[:name] }[:nullable?]
        end
        
        def required?
          required
        end

        def serial
          abstract_model.properties.find { |column| name == column[:name] }[:serial?]
        end        

        def serial?
          serial
        end
      end

      # A field configuration identified by the name of the column.
      class Named < RailsAdmin::Config::Fields::Base
        attr_reader :name

        def initialize(name, parent)
          super(parent)
          @name = name
        end
        
        def type(type = nil, &block)
          if type || block
            @type = type
          else
            type = @type || abstract_model.properties.find { |column| name == column[:name] }[:type]
            instance_eval &type if type.kind_of?(Proc)
            type
          end
        end

        # Configuration value lookup strategy for named fields. 
        #
        # @see RailsAdmin::Config::Base.read_option
        def read_option(option_name, recursive = true)
          value = super(option_name)          
          if recursive
            shared = RailsAdmin::Config.shared_model(abstract_model)            
            unless parent.shared?
              if parent_is_section?
                # Query current model's main configuration by the name of current field
                value = parent.parent.field(name).read_option(option_name, false) if value.nil?
              end
              # Query parent (either section or model's main configuration) by the type of current field
              value = parent.field_of_type(type, name).read_option(option_name, false) if value.nil?
              if parent_is_section?
                # Query current model's main configuration by the type of current field
                value = parent.parent.field_of_type(type, name).read_option(option_name, false) if value.nil?
                # Query shared model's section by the type of current field. 
                value = shared.send(parent.section_name).field_of_type(type, name).read_option(option_name, false) if value.nil? 
              end
            end
            # For non shared configurations and all section configurations
            if !parent.shared? || parent_is_section?
              # Query shared model's main configuration by the type of current field. 
              value = shared.field_of_type(type, name).read_option(option_name, false) if value.nil?
            end
          end
          value          
        end
        
        def to_hash
          {
            :name => name,
            :pretty_name => label,
            :type => type,
            :length => length,
            :nullable? => required,
            :searchable? => searchable,            
            :serial? => serial,            
            :sortable? => sortable,            
          }
        end
      end
      
      # A field configuration identified by the type of the column.
      class Typed < RailsAdmin::Config::Fields::Base
        attr_accessor :name
        attr_reader :type

        def initialize(type, parent)
          super(parent)
          @name = nil
          @type = type
        end

        # Configuration value lookup strategy for typed fields. 
        #
        # @see RailsAdmin::Config::Base.read_option
        def read_option(option_name, recursive = true)
          value = super(option_name)          
          if recursive
            shared = RailsAdmin::Config.shared_model(abstract_model)            
            # For non shared section configurations
            if !parent.shared? && parent_is_section?
              # Query current model's main configuration by the type of current field
              value = parent.parent.field_of_type(type, name).read_option(option_name, false) if value.nil?
              # Query shared model's section by the type of current field. 
              value = shared.send(parent.section_name).field_of_type(type, name).read_option(option_name, false) if value.nil? 
            end
            # For non shared configurations and all section configurations
            if !parent.shared? || parent_is_section?
              # Query shared model's main configuration by the type of current field. 
              value = shared.field_of_type(type, name).read_option(option_name, false) if value.nil?
            end
          end
          value
        end
      end
    end

    # Sections describe different views in the RailsAdmin engine. Configurable sections are
    # edit, list and navigation.
    #
    # Each section's class object can store generic configuration about that section (such as the 
    # number of visible tabs in the main navigation), while the instances (accessed via model
    # configuration objects) store model specific configuration (such as the label of the
    # model to be used as the title in the main navigation tabs).
    module Sections
      def self.included(klass)
        # Register accessors for all the sections in this namespace
        constants.each do |name|
          section = "RailsAdmin::Config::Sections::#{name}".constantize
          name = name.to_s.downcase
          klass.send(:define_method, name) do |&block|
            @sections ||= {}
            @sections[name] ||= section.new(self)
            @sections[name].instance_eval &block if block
            @sections[name]
          end
          # Register a shortcut to define the model's label for each section.
          klass.send(:define_method, "label_for_#{name}") do |*args, &block|
            send(name).label(args[0] || block)
          end
          # Register a shortcut to hide the model for each section.
          klass.send(:define_method, "hide_in_#{name}") do |&block|
            send(name).visible(block ? proc { false == (instance_eval &block) } : false)
          end
          # Register a shortcut to show the model for each section.
          klass.send(:define_method, "show_in_#{name}") do |&block|
            send(name).visible(block || true)
          end
        end
      end

      # Base class for the section configurations
      class Base < RailsAdmin::Config::Base

        # Configuration value lookup strategy for sections.
        #
        # @see RailsAdmin::Config::Base.read_option
        def read_option(option_name, recursive = true)
          value = super(option_name)
          if recursive
            # Query current model's main configuration. Current model can either be 
            # a concrete application model or the shared model
            value = parent.read_option(option_name, false) if value.nil?
            # For all non shared configurations
            unless parent.shared?
              shared_model = RailsAdmin::Config.shared_model(abstract_model)
              # Query shared model's section configuration
              value = shared_model.send(section_name).read_option(option_name, false) if value.nil?
              # Query shared model's main configuration 
              value = shared_model.read_option(option_name, false) if value.nil?
            end
          end
          value
        end

        def section_name
          @section_name ||= self.class.name.split("::")[-1].downcase
        end

        # Sections are shared if parent is kind of RailsAdmin::Config::SharedModel
        def shared?
          @shared ||= parent.kind_of?(RailsAdmin::Config::SharedModel)
        end
      end

      # Configuration of the edit view
      class Edit < RailsAdmin::Config::Sections::Base        
        include RailsAdmin::Config::Fields
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable
      end

      # Configuration of the list view
      class List < RailsAdmin::Config::Sections::Base
        include RailsAdmin::Config::Fields
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable

        # Number of items listed per page
        register_option(:items_per_page) do
          20
        end
      end
      
      # Configuration of the navigation view
      class Navigation < RailsAdmin::Config::Sections::Base
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable

        @@max_visible_tabs = 5

        # The number of tabs visible in the main navigation
        def self.max_visible_tabs(value = nil, &block)
          if value || block
            @@max_visible_tabs = value || block
          else
            value = @@max_visible_tabs
            value = instance_eval value if value.kind_of?(Proc)
            value
          end
        end
        
        def self.max_visible_tabs=(value)
          @@max_visible_tabs = value
        end

        # Get all models that are configured as visible 
        #
        # @see RailsAdmin::Config::Hideable
        def self.visible_models
          RailsAdmin::AbstractModel.all.select do |m|
            RailsAdmin.config(m.model).navigation.visible?
          end
        end        
      end            
    end
    
    # Model specific configuration object
    class Model < RailsAdmin::Config::Base            
      include RailsAdmin::Config::Fields
      include RailsAdmin::Config::Hideable
      include RailsAdmin::Config::Labelable
      include RailsAdmin::Config::Sections
      
      attr_reader :abstract_model
      
      def initialize(abstract_model, parent)
        @abstract_model = abstract_model
        super(parent)
      end
      
      # Configuration value lookup strategy for model configurations.
      #
      # @see RailsAdmin::Config::Base.read_option
      def read_option(option_name, recursive = true)
        value = super(option_name)
        # Query shared model's main configuration 
        value = RailsAdmin::Config.shared_model(abstract_model).read_option(option_name, false) if value.nil? && recursive
        value
      end      
    end
    
    # Fallback configuration object shared by all models configurations
    class SharedModel < RailsAdmin::Config::Base      
      include RailsAdmin::Config::Fields
      include RailsAdmin::Config::Hideable
      include RailsAdmin::Config::Labelable
      include RailsAdmin::Config::Sections

      attr_accessor :abstract_model
      
      # @see RailsAdmin::Config::Base.shared?
      def shared?
        true
      end
    end
  end
end