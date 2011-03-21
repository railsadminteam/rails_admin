module RailsAdmin
  module Config
    module Fields
      # Default field factory loads fields based on their property type or
      # association type.
      #
      # @see RailsAdmin::Config::Fields.registry
      mattr_reader :default_factory
      @@default_factory = lambda do |parent, properties, fields|
        # Belongs to association need special handling as they also include a column in the table
        if association = parent.abstract_model.belongs_to_associations.find {|a| a[:child_key].first.to_s == properties[:name].to_s}
          type = association[:options][:polymorphic] ? :polymorphic_association : :belongs_to_association
          fields << RailsAdmin::Config::Fields::Types.load(type).new(parent, properties[:name], properties, association)
          # Polymorphic associations type column should be hidden
          if association[:options][:polymorphic]
            props = parent.abstract_model.properties.find {|p| association[:options][:foreign_type] == p[:name].to_s }
            RailsAdmin::Config::Fields.default_factory.call(parent, props, fields)
            fields.last.hide
          end
        # If it's an association
        elsif properties.has_key?(:parent_model) && :belongs_to != properties[:type]
          fields << RailsAdmin::Config::Fields::Types.load("#{properties[:type]}_association").new(parent, properties[:name], properties)
        # If it's a concrete column
        elsif !properties.has_key?(:parent_model)
          fields << RailsAdmin::Config::Fields::Types.load(properties[:type]).new(parent, properties[:name], properties)
        end
      end

      # Registry of field factories.
      #
      # Field factory is an anonymous function that recieves the parent object,
      # an array of field properties and an array of fields already instantiated.
      #
      # If the factory returns true then that property will not be run through
      # the rest of the registered factories. If it returns false then the
      # arguments will be passed to the next factory.
      #
      # By default a basic factory is registered which loads fields by their
      # database column type. Also a password factory is registered which
      # loads fields if their name is password. Third default factory is a
      # devise specific factory which loads fields for devise user models.
      #
      # @see RailsAdmin::Config::Fields.register_factory
      # @see rails_admin/config/fields/factories/password.rb
      # @see rails_admin/config/fields/factories/devise.rb
      @@registry = [@@default_factory]

      # Build an array of fields by the provided parent object's abstract_model's
      # property and association information. Each property and association is
      # passed to the registered field factories which will populate the fields
      # array that will be returned.
      #
      # @see RailsAdmin::Config::Fields.registry
      def self.factory(parent)
        fields = []
        return fields unless parent.abstract_model.model_store_exists?
        # Load fields for all properties (columns)
        parent.abstract_model.properties.each do |properties|
          # Unless a previous factory has already loaded current field as well
          unless fields.find {|f| f.name == properties[:name] }
            # Loop through factories until one returns true
            @@registry.find {|factory| factory.call(parent, properties, fields) }
          end
        end
        # Load fields for all associations (relations)
        parent.abstract_model.associations.each do |association|
          # Unless a previous factory has already loaded current field as well
          unless fields.find {|f| f.name == association[:name] }
            # Loop through factories until one returns true
            @@registry.find {|factory| factory.call(parent, association, fields) }
          end
        end
        fields
      end

      # Register a field factory to be included in the factory stack.
      #
      # Factories are invoked lifo (last in first out).
      #
      # @see RailsAdmin::Config::Fields.registry
      def self.register_factory(&block)
        @@registry.unshift(block)
      end
    end
  end
end

require 'rails_admin/config/fields/types'
require 'rails_admin/config/fields/factories/password'
require 'rails_admin/config/fields/factories/devise'
require 'rails_admin/config/fields/factories/paperclip'
