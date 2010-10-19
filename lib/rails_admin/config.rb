require "rails_admin/fields"

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

    # Loads a model configuration instance from the registry or registers
    # a new one if one is yet to be added.
    #
    # First argument can be an instance of requested model, it's class object,
    # it's class name as a string or symbol or a RailsAdmin::AbstractModel
    # instance.
    #
    # If a block is given it is evaluated in the context of configuration instance.
    #
    # If first argument is omitted and a block is given it will be evaluated in
    # the context of all model configurations.
    #
    # Returns given model's configuration or the shared fallback model configuration.
    #
    # @see RailsAdmin::Config.registry
    def self.model(entity = nil, &block)
      if entity.nil?
        if block
          models.each {|config| config.instance_eval &block }
        end
      else
        if entity.kind_of?(RailsAdmin::AbstractModel)
          key = entity.model.name.to_sym
          config = @@registry[key] ||= Model.new(entity)
        elsif entity.kind_of?(Class) || entity.kind_of?(String) || entity.kind_of?(Symbol)
          key = entity.kind_of?(Class) ? entity.name.to_sym : entity.to_sym
          config = @@registry[key] ||= Model.new(RailsAdmin::AbstractModel.new(entity))
        else
          key = entity.class.name.to_sym
          config = @@registry[key] ||= Model.new(RailsAdmin::AbstractModel.new(entity.class))
          config.bind(:object, entity)
        end
        config.instance_eval &block if block
        config
      end
    end

    # Returns all model configurations
    #
    # @see RailsAdmin::Config.registry
    def self.models
      RailsAdmin::AbstractModel.all.each do |m|
        @@registry[m.model.name.to_sym] ||= Model.new(m)
      end
      @@registry.values
    end

    # Reset all model configurations.
    #
    # @see RailsAdmin::Config.registry
    def self.reset
      @@registry.clear
    end

    # A base for all configurables.
    #
    # Each configurable has a parent object. This parent object must provide
    # the configurable with abstract_model and bindings.
    #
    # Bindings is a hash of variables bound by the querying context. For
    # example the list view's template will bind an object to key
    # :object for each row it outputs. This object is the actual row object
    # which is then used as the receiver of queries for property values.
    #
    # @see RailsAdmin::AbstractModel
    # @see RailsAdmin::Config::Model#bindings
    # @see RailsAdmin::Config::Model#abstract_model
    class Configurable
      attr_reader :abstract_model, :bindings, :parent

      def initialize(parent)
        @abstract_model = parent.abstract_model
        @bindings = parent.bindings
        @parent = parent
      end

      # Register an instance option. Instance option is a configuration
      # option that stores it's value within an instance variable and is
      # accessed by an instance method. Both go by the name of the option.
      def self.register_instance_option(option_name, &default)
        option_name = option_name.to_s

        # If it's a boolean create an alias for it and remove question mark
        if "?" == option_name[-1, 1]
          send(:define_method, "#{option_name.chop!}?") do
            send(option_name)
          end
        end

        # Define setter by the option name
        send(:define_method, "#{option_name}=") do |value|
          instance_variable_set("@#{option_name}", value)
        end

        # Define getter/setter by the option name
        send(:define_method, option_name) do |*args, &block|
          if !args[0].nil? || block
            instance_variable_set("@#{option_name}", args[0].nil? ? block : args[0])
          else
            value = instance_variable_get("@#{option_name}")
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

      # Register a class option. Class option is a configuration
      # option that stores it's value within a class variable and is
      # accessed by a class method. Both go by the name of the option.
      def self.register_class_option(option_name, &default)
        option_name = option_name.to_s

        class_variable_set("@@#{option_name}", nil)

        # If it's a boolean create an alias for it and remove question mark
        if "?" == option_name[-1, 1]
          self.class.send(:define_method, "#{option_name.chop!}?") do
            send(option_name)
          end
        end

        # Define setter by the option name
        self.class.send(:define_method, "#{option_name}=") do |value|
          class_variable_set("@@#{option_name}", value)
        end

        # Define getter/setter by the option name
        self.class.send(:define_method, option_name) do |*args, &block|
          if !args[0].nil? || block
            class_variable_set("@@#{option_name}", args[0].nil? ? block : args[0])
          else
            value = class_variable_get("@@#{option_name}")
            value = default if value.nil?
            if value.kind_of?(Proc)
              value = class_eval &value
            end
            value
          end
        end
      end
    end

    # Defines a generic label/name/title configuration
    module Labelable
      def self.included(klass)
        klass.register_instance_option(:label) do
          abstract_model.pretty_name
        end
        klass.register_instance_option(:object_label) do
          if bindings[:object].respond_to?(:name) && bindings[:object].name
            bindings[:object].name
          elsif bindings[:object].respond_to?(:title) && bindings[:object].title
            bindings[:object].title
          else
            "#{bindings[:object].class.to_s} ##{bindings[:object].id}"
          end
        end
      end
    end

    # Defines a visibility configuration
    module Hideable
      # Visibility defaults to true.
      def self.included(klass)
        klass.register_instance_option(:visible) do
          true
        end
      end

      # Reader whether field is hidden.
      def hidden?
        not visible
      end

      # Writer to hide field.
      def hide(&block)
        visible block ? proc { false == (instance_eval &block) } : false
      end

      # Writer to show field.
      def show(&block)
        visible block || true
      end

      # Reader whether field is visible.
      def visible?
        visible
      end
    end

    # Fields describe the configuration for model's properties that RailsAdmin will
    # use when rendering the list and edit views.
    module Fields
      # Populate the extended object's @fields instance variable with model's properties
      def self.extended(obj)
        fields = obj.abstract_model.properties.map {|p| Field.new(obj, p[:name], p[:type]) }
        obj.instance_variable_set("@fields", fields)
      end

      # Defines a configuration for a field.
      def field(name, &block)
        field = @fields.find {|f| name == f.name }
        # Allow the addition of virtual fields such as object methods
        if field.nil?
          field = (@fields << Virtual.new(self, name)).last
        end
        # If field has not been yet defined add some default properties
        unless field.defined
          field.defined = true
          field.order = @fields.select {|f| f.defined }.length
          field.visible = true
        end
        # If a block has been given evaluate it and sort fields after that
        if block
          field.instance_eval &block
          @fields.sort! {|a, b| a.order <=> b.order }
        end
        field
      end

      # Returns all field configurations for the model configuration instance. If no fields
      # have been defined returns all fields. Defined fields are sorted to match their
      # order property. If order was not specified it will match the order in which fields
      # were defined.
      def fields
        defined = @fields.select {|f| f.defined }
        defined.sort! {|a, b| a.order <=> b.order }
        defined = @fields if defined.empty?
        defined
      end

      # Defines configuration for fields by their type.
      def fields_of_type(type, &block)
        selected = @fields.select {|f| type == f.type }
        if block
          selected.each {|f| f.instance_eval &block }
        end
        selected
      end

      # Get all fields defined as visible.
      def visible_fields
        fields.select {|f| f.visible? }
      end

      # A base class for configuring the fields of models.
      class Field < RailsAdmin::Config::Configurable
        attr_reader :name, :type
        attr_accessor :defined, :order

        include RailsAdmin::Config::Hideable

        def initialize(parent, name, type = nil)
          super(parent)
          @defined = false
          @name = name
          @order = 0
          @type = type || abstract_model.properties.find {|column| name == column[:name] }[:type]
        end

        # Accessor for field's column width (in pixels) in the list view
        register_instance_option(:column_width) do
          RailsAdmin::Fields.load(type).column_width
        end

        # Accessor for field's css class name in the list view
        register_instance_option(:column_css_class) do
          RailsAdmin::Fields.load(type).column_css_class
        end

        # Accessor for field's label.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:label) do
          abstract_model.properties.find {|column| name == column[:name] }[:pretty_name]
        end

        # Accessor for field's maximum length.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:length) do
          abstract_model.properties.find {|column| name == column[:name] }[:length]
        end

        # Accessor for whether this field is searchable.
        register_instance_option(:searchable?) do
          RailsAdmin::Fields.load(type).searchable?
        end

        # Accessor for whether this field is sortable.
        register_instance_option(:sortable?) do
          RailsAdmin::Fields.load(type).sortable?
        end

        # Accessor for field's value
        register_instance_option(:value) do
          bindings[:object].send(name)
        end

        def to_hash
          {
            :name => name,
            :pretty_name => label,
            :type => type,
            :length => length,
            :nullable? => required?,
            :searchable? => searchable?,
            :serial? => serial?,
            :sortable? => sortable?,
          }
        end

        # Reader for whether this is field is mandatory.
        #
        # @see RailsAdmin::AbstractModel.properties
        def required?
          abstract_model.properties.find {|column| name == column[:name] }[:nullable?]
        end

        # Reader for whether this is a serial field (aka. primary key, identifier).
        #
        # @see RailsAdmin::AbstractModel.properties
        def serial?
          abstract_model.properties.find {|column| name == column[:name] }[:serial?]
        end
      end

      # A base class for configuring the fields of models.
      class Virtual < Field

        def initialize(parent, name)
          super(parent, name, :virtual)
        end

        # Accessor for field's column width (in pixels) in the list view
        register_instance_option(:column_width) do
          RailsAdmin::Fields.load(type).column_width
        end

        # Accessor for field's css class name in the list view
        register_instance_option(:column_css_class) do
          RailsAdmin::Fields.load(type).column_css_class
        end

        # Accessor for field's label.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:label) do
          name
        end

        # Accessor for field's maximum length.
        #
        # @see RailsAdmin::AbstractModel.properties
        register_instance_option(:length) do
          100
        end

        # Accessor for whether this field is searchable.
        register_instance_option(:searchable?) do
          false
        end

        # Accessor for whether this field is sortable.
        register_instance_option(:sortable?) do
          false
        end

        # Reader for whether this is field is mandatory.
        #
        # @see RailsAdmin::AbstractModel.properties
        def required?
          false
        end

        # Reader for whether this is a serial field (aka. primary key, identifier).
        #
        # @see RailsAdmin::AbstractModel.properties
        def serial?
          false
        end
      end
    end

    # Sections describe different views in the RailsAdmin engine. Configurable sections are
    # list and navigation.
    #
    # Each section's class object can store generic configuration about that section (such as the
    # number of visible tabs in the main navigation), while the instances (accessed via model
    # configuration objects) store model specific configuration (such as the label of the
    # model to be used as the title in the main navigation tabs).
    module Sections
      def self.extended(obj)
        sections = obj.instance_variable_set("@sections", {});
        constants.each do |name|
          section = "RailsAdmin::Config::Sections::#{name}".constantize
          name = name.to_s.downcase
          sections[name] = section.new(obj)
        end
      end

      def self.included(klass)
        # Register accessors for all the sections in this namespace
        constants.each do |name|
          section = "RailsAdmin::Config::Sections::#{name}".constantize
          name = name.to_s.downcase
          klass.send(:define_method, name) do |&block|
            @sections[name].instance_eval &block if block
            @sections[name]
          end
          # Register a shortcut to define the model's label for each section.
          klass.send(:define_method, "label_for_#{name}") do |*args, &block|
            send(name).label(block ? block : args[0])
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

      # Configuration of the list view
      class List < RailsAdmin::Config::Configurable
        include RailsAdmin::Config::Fields
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable

        def initialize(parent)
          super(parent)
          extend RailsAdmin::Config::Fields
        end

        # Default items per page value used if a model level option has not
        # been configured
        cattr_accessor :default_items_per_page
        @@default_items_per_page = 20

        # Number of items listed per page
        register_instance_option(:items_per_page) do
          RailsAdmin::Config::Sections::List.default_items_per_page
        end
      end

      # Configuration of the navigation view
      class Navigation < RailsAdmin::Config::Configurable
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable

        # Defines the number of tabs to be renderer in the main navigation.
        # Rest of the links will be rendered to a drop down menu.
        register_class_option(:max_visible_tabs) do
          5
        end

        # Get all models that are configured as visible sorted by their label.
        #
        # @see RailsAdmin::Config::Hideable
        def self.visible_models
          RailsAdmin::Config.models
            .select {|m| m.navigation.visible? }
            .sort {|a, b| a.navigation.label <=> b.navigation.label }
        end
      end
    end

    # Model specific configuration object.
    class Model < Configurable
      include RailsAdmin::Config::Sections

      def initialize(abstract_model)
        @abstract_model = abstract_model
        @bindings = {}
        @parent = nil
        extend RailsAdmin::Config::Sections
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

      # Act as a proxy for the section configurations that actually
      # store the configurations.
      def method_missing(m, *args, &block)
        if block || args
          @sections.each do |key, s|
            s.send(m, *args, &block) if s.respond_to?(m)
          end
        end
      end
    end
  end
end