require 'rails_admin/config'
require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/has_groups'
require 'rails_admin/config/fields/group'
require 'rails_admin/config/fields'
require 'rails_admin/config/has_fields'
require 'rails_admin/config/sections'
require 'rails_admin/config/actions'


module RailsAdmin
  module Config
    # Model specific configuration object.
    class Model < RailsAdmin::Config::Base
      include RailsAdmin::Config::Hideable
      include RailsAdmin::Config::Sections
      
      attr_reader :abstract_model
      attr_accessor :groups
      
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
        
        @groups = [ RailsAdmin::Config::Fields::Group.new(self, :default).tap {|g| g.label{I18n.translate("admin.form.basic_info")} } ]
        @bindings = {}
        @parent = nil
        @root = self
      end

      def excluded?
        @excluded ||= !RailsAdmin::AbstractModel.all.map(&:model).include?(abstract_model.model)
      end

      def object_label
        bindings[:object].send object_label_method
      end

      # The display for a model instance (i.e. a single database record).
      # Unless configured in a model config block, it'll try to use :name followed by :title methods, then
      # any methods that may have been added to the label_methods array via Configuration.
      # Failing all of these, it'll return the class name followed by the model's id.
      register_instance_option(:object_label_method) do
        @object_label_method ||= Config.label_methods.find { |method| (@dummy_object ||= abstract_model.model.new).respond_to? method } || :rails_admin_default_object_label_method
      end

      register_instance_option(:label) do
        (@label ||= {})[::I18n.locale] ||= abstract_model.model.model_name.human(:default => abstract_model.model.model_name.demodulize.underscore.humanize)
      end

      register_instance_option(:label_plural) do
        (@label_plural ||= {})[::I18n.locale] ||= abstract_model.model.model_name.human(:count => 2, :default => label.pluralize)
      end

      register_instance_option(:weight) do
        0
      end

      register_instance_option(:parent) do
        :root
      end

      register_instance_option(:navigation_label) do
        false
      end

      # Act as a proxy for the base section configuration that actually
      # store the configurations.
      def method_missing(m, *args, &block)
        self.send(:base).send(m, *args, &block)
      end
    end
  end
end
