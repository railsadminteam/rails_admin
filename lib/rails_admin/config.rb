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

    def self.global(abstract_model = nil, &block)
      config = load(nil, block)
      config.abstract_model = abstract_model
      config
    end

    # Alias for model specific configuration for nicer syntax in an initializer.
    #
    # @see RailsAdmin::Config.load
    def self.model(entity = nil, &block)
      load(entity, block)
    end
    
    # Loads given model's configuration instance from the registry or registers 
    # a new one if one is yet to be added.
    #
    # If a block is given it is evaluated in the context of configuration instance.
    #
    # Returns given model's configuration.
    #
    # @see RailsAdmin::Config.registry
    def self.load(entity = nil, block = nil)      
      if entity.nil?
        config = @@global ||= RailsAdmin::Config::Global.new(self)
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
    
    # Reset a model's configuration.
    #
    # @see RailsAdmin::Config.load
    def self.reset(entity = nil)
      if entity.nil?
        @@global = nil
        @@registry = {}
      else
        config = self.load(entity)
        @@registry[config.abstract_model.model.name] = nil
      end
    end

    def self.navigation
      RailsAdmin::Config::Navigation
    end

    module Navigation
      @@max_visible_tabs = 5
      mattr_accessor :max_visible_tabs

      # Get all models that are configured as visible 
      def self.visible_models
        RailsAdmin::AbstractModel.all.select do |m|
          RailsAdmin.config(m.model).navigation.visible
        end
      end        
    end
    
    class Base                
      attr_reader :parent, :section_name

      def initialize(parent)
        @parent = parent
        @section_name = self.class.name.split("::")[-1].downcase
      end

      def abstract_model
        parent.abstract_model
      end

      def model
        abstract_model.model
      end

      def read_option(option_name, recursive = true)
        value = instance_variable_get("@#{option_name}")
        if recursive
          value = parent.read_option(option_name, false) if value.nil?
          value = RailsAdmin::Config.global(abstract_model).send(section_name).read_option(option_name, false) if value.nil?
          value = RailsAdmin::Config.global(abstract_model).read_option(option_name, false) if value.nil?
        end
        value
      end

      def section?
        false
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
    end

    module Labelable
      def self.included(klass)
        klass.register_option(:label) do
          abstract_model.pretty_name
        end
      end
    end
    
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
    
    module Fields
      def field(name, &block)
        @named_fields ||= []
        field = @named_fields.find { |f| name == f.name } || (@named_fields << RailsAdmin::Config::Fields::Named.new(name, self))[-1]
        field.instance_eval &block if block
        field
      end

      def field_of_type(type, name = nil, &block)
        @typed_fields ||= []
        field = @typed_fields.find { |f| type == f.type } || (@typed_fields << RailsAdmin::Config::Fields::Typed.new(type, self))[-1]
        field.instance_eval &block if block
        field.name = name
        field
      end

      def fields
        @named_fields ||= abstract_model.properties.map do |p| 
          RailsAdmin::Config::Fields::Named.new(p[:name], self)
        end
      end

      class Base < RailsAdmin::Config::Base
        include RailsAdmin::Config::Hideable

        register_option(:label) do
          abstract_model.properties.find { |column| name == column[:name] }[:pretty_name]
        end

        register_option(:length) do
          abstract_model.properties.find { |column| name == column[:name] }[:length]
        end

        register_option(:searchable) do
          type == :string
        end

        register_option(:sortable) do
          true
        end

        def required
          abstract_model.properties.find { |column| name == column[:name] }[:nullable?]
        end        

        def serial
          abstract_model.properties.find { |column| name == column[:name] }[:serial?]
        end        
      end

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

        def read_option(option_name, recursive = true)
          value = instance_variable_get("@#{option_name}")
          if recursive
            value = parent.parent.field(name).read_option(option_name, false) if value.nil?
            value = parent.field_of_type(type, name).read_option(option_name, false) if value.nil?
            value = parent.parent.field_of_type(type, name).read_option(option_name, false) if value.nil?
            if parent.section?
              value = RailsAdmin::Config.global(abstract_model).send(parent.section_name).field_of_type(type, name).read_option(option_name, false) if value.nil?
              value = RailsAdmin::Config.global(abstract_model).field_of_type(type, name).read_option(option_name, false) if value.nil?
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

      class Typed < RailsAdmin::Config::Fields::Base
        attr_accessor :name
        attr_reader :type

        def initialize(type, parent)
          super(parent)
          @name = nil
          @type = type
        end

        def read_option(option_name, recursive = true)
          value = instance_variable_get("@#{option_name}")
          if recursive
            value = parent.parent.field_of_type(type, name).read_option(option_name, false) if value.nil?
            if parent.section?
              value = RailsAdmin::Config.global(abstract_model).send(parent.section_name).field_of_type(type, name).read_option(option_name, false) if value.nil?
              value = RailsAdmin::Config.global(abstract_model).field_of_type(type, name).read_option(option_name, false) if value.nil?
            end
          end
          value          
        end
      end
    end

    module Sections
      def self.included(klass)
        constants.each do |name|
          section = "RailsAdmin::Config::Sections::#{name}".constantize
          name = name.to_s.downcase
          klass.send(:define_method, name) do |&block|
            @sections ||= {}
            @sections[name] ||= section.new(self)
            @sections[name].instance_eval &block if block
            @sections[name]
          end
          klass.send(:define_method, "label_for_#{name}") do |*args, &block|
            send(name).label(args[0] || block)
          end
          klass.send(:define_method, "hide_in_#{name}") do |&block|
            send(name).visible(block ? proc { false == (instance_eval &block) } : false)
          end
          klass.send(:define_method, "show_in_#{name}") do |&block|
            send(name).visible(block || true)
          end
        end
      end

      class Base < RailsAdmin::Config::Base
        def section?
          false
        end
      end

      class Edit < RailsAdmin::Config::Sections::Base        
        include RailsAdmin::Config::Fields
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable
      end

      class List < RailsAdmin::Config::Sections::Base
        include RailsAdmin::Config::Fields
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable

        register_option(:per_page) do
          20
        end
      end
      
      class Navigation < RailsAdmin::Config::Sections::Base
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable
      end            
    end
    
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
      
      def read_option(option_name, recursive = true)
        value = instance_variable_get("@#{option_name}")
        value = RailsAdmin::Config.global(abstract_model).read_option(option_name, false) if value.nil? && recursive
        value
      end      
    end
    
    class Global < RailsAdmin::Config::Base      
      include RailsAdmin::Config::Fields
      include RailsAdmin::Config::Hideable
      include RailsAdmin::Config::Labelable
      include RailsAdmin::Config::Sections

      attr_accessor :abstract_model
      
      def read_option(option_name, recursive = true)
        instance_variable_get("@#{option_name}")
        value = RailsAdmin::Config.global(abstract_model).read_option(option_name, false) if value.nil? && recursive && !top_level_configuration?
      end      
    end
  end
end