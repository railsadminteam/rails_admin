module RailsAdmin
  module Config
    # Provides accessors and autoregistering of model's fields.
    module HasFields
      # Defines a configuration for a field.
      def field(name, type = nil, &block)
        field = @fields.find {|f| name == f.name }
        # Specify field as virtual if type is not specifically set and field was not
        # found in default stack
        if field.nil? && type.nil?
          field = (@fields << RailsAdmin::Config::Fields::Types.load(:virtual).new(self, name, {})).last
        # Register a custom field type if one is provided and it is different from
        # one found in default stack
        elsif !type.nil? && type != (field.nil? ? nil : field.type)
          @fields.delete(field) unless field.nil?
          properties = parent.abstract_model.properties.find {|p| name == p[:name] }
          field = (@fields <<  RailsAdmin::Config::Fields::Types.load(type).new(self, name, properties)).last
        end
        # If field has not been yet defined add some default properties
        unless field.defined
          field.defined = true
          field.order = @fields.select(&:defined).length
        end
        # If a block has been given evaluate it and sort fields after that
        if block
          field.instance_eval &block
          @fields.sort! {|a, b| a.order <=> b.order }
        end
        field
      end

      # include fields by name and apply an optionnal block to each (through a call to fields),
      # or include fields by conditions if no field names
      def include_fields(*field_names, &block)
        if field_names.empty?
          @fields.select {|f| f.instance_eval &block }.each do |f|
            unless f.defined
              f.defined = true
              f.order = @fields.select(&:defined).length
            end
          end
        else
          fields(*field_names, &block)
        end
      end

      # exclude fields by name or by condition (block)
      def exclude_fields(*field_names, &block)
        block ||= lambda { |f| field_names.include?(f.name) }
        @fields.each {|f| f.defined = true } if @fields.select(&:defined).empty?
        @fields.select {|f| f.instance_eval &block }.each {|f| f.defined = false }
      end

      # API candy
      alias :exclude_fields_if :exclude_fields
      alias :include_fields_if :include_fields

      # does pretty much what it says in the can
      def include_all_fields
        include_fields_if() { true }
      end

      # Returns all field configurations for the model configuration instance. If no fields
      # have been defined returns all fields. Defined fields are sorted to match their
      # order property. If order was not specified it will match the order in which fields
      # were defined.
      #
      # If a block is passed it will be evaluated in the context of each field
      def fields(*field_names,&block)
        if field_names.empty?
          defined = @fields.select {|f| f.defined }
          defined.sort! {|a, b| a.order <=> b.order }
          defined = @fields if defined.empty?
          if block
            defined.each {|f| f.instance_eval &block }
          end
          defined
        else
          defined = field_names.map{|field_name| @fields.find {|f| f.name == field_name } }
          defined.map do |f|
            unless f.defined
              f.defined = true
              f.order = @fields.select(&:defined).length
            end
            f.instance_eval(&block) if block
            f
          end
        end
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
    end
  end
end