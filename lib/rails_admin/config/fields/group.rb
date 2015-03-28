require 'active_support/core_ext/string/inflections'
require 'rails_admin/config/proxyable'
require 'rails_admin/config/configurable'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Fields
      # A container for groups of fields in edit views
      class Group
        include RailsAdmin::Config::Proxyable
        include RailsAdmin::Config::Configurable
        include RailsAdmin::Config::Hideable

        attr_reader :name, :abstract_model
        attr_accessor :section
        attr_reader :parent, :root

        def initialize(parent, name)
          @parent = parent
          @root = parent.root

          @abstract_model = parent.abstract_model
          @section = parent
          @name = name.to_s.tr(' ', '_').downcase.to_sym
        end

        # Defines a configuration for a field by proxying parent's field method
        # and setting the field's group as self
        #
        # @see RailsAdmin::Config::Fields.field
        def field(name, type = nil, &block)
          field = section.field(name, type, &block)
          # Directly manipulate the variable instead of using the accessor
          # as group probably is not yet registered to the parent object.
          field.instance_variable_set('@group', self)
          field
        end

        # Reader for fields attached to this group
        def fields
          section.fields.select { |f| f.group == self }
        end

        # Defines configuration for fields by their type
        #
        # @see RailsAdmin::Config::Fields.fields_of_type
        def fields_of_type(type, &block)
          selected = section.fields.select { |f| type == f.type }
          selected.each { |f| f.instance_eval(&block) } if block
          selected
        end

        # Reader for fields that are marked as visible
        def visible_fields
          section.with(bindings).visible_fields.select { |f| f.group == self }
        end

        # Should it open by default
        register_instance_option :active? do
          true
        end

        # Configurable group label which by default is group's name humanized.
        register_instance_option :label do
          (@label ||= {})[::I18n.locale] ||= (parent.fields.detect { |f| f.name == name }.try(:label) || name.to_s.humanize)
        end

        # Configurable help text
        register_instance_option :help do
          nil
        end
      end
    end
  end
end
