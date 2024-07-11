

require 'rails_admin/config'
require 'rails_admin/config/proxyable'
require 'rails_admin/config/configurable'
require 'rails_admin/config/hideable'
require 'rails_admin/config/has_groups'
require 'rails_admin/config/fields/group'
require 'rails_admin/config/fields'
require 'rails_admin/config/has_fields'
require 'rails_admin/config/has_description'
require 'rails_admin/config/sections'
require 'rails_admin/config/actions'
require 'rails_admin/config/inspectable'

module RailsAdmin
  module Config
    # Model specific configuration object.
    class Model
      include RailsAdmin::Config::Proxyable
      include RailsAdmin::Config::Configurable
      include RailsAdmin::Config::Hideable
      include RailsAdmin::Config::Sections
      include RailsAdmin::Config::Inspectable

      attr_reader :abstract_model, :parent, :root
      attr_accessor :groups

      NAMED_INSTANCE_VARIABLES = %i[@parent @root].freeze

      def initialize(entity)
        @parent = nil
        @root = self

        @abstract_model =
          case entity
          when RailsAdmin::AbstractModel
            entity
          when Class, String
            RailsAdmin::AbstractModel.new(entity)
          when Symbol
            RailsAdmin::AbstractModel.new(entity.to_s)
          else
            RailsAdmin::AbstractModel.new(entity.class)
          end

        @groups = [RailsAdmin::Config::Fields::Group.new(self, :default).tap { |g| g.label { I18n.translate('admin.form.basic_info') } }]
      end

      def excluded?
        return @excluded if defined?(@excluded)

        @excluded = !RailsAdmin::AbstractModel.all.collect(&:model_name).include?(abstract_model.try(:model_name))
      end

      def object_label
        bindings[:object].send(object_label_method).presence ||
          bindings[:object].send(:rails_admin_default_object_label_method)
      end

      # The display for a model instance (i.e. a single database record).
      # Unless configured in a model config block, it'll try to use :name followed by :title methods, then
      # any methods that may have been added to the label_methods array via Configuration.
      # Failing all of these, it'll return the class name followed by the model's id.
      register_instance_option :object_label_method do
        @object_label_method ||= Config.label_methods.detect { |method| (@dummy_object ||= abstract_model.model.new).respond_to? method } || :rails_admin_default_object_label_method
      end

      register_instance_option :label do
        (@label ||= {})[::I18n.locale] ||= abstract_model.model.model_name.human
      end

      register_instance_option :label_plural do
        (@label_plural ||= {})[::I18n.locale] ||= abstract_model.model.model_name.human(count: Float::INFINITY, default: label.pluralize(::I18n.locale))
      end

      def pluralize(count)
        count == 1 ? label : label_plural
      end

      register_instance_option :weight do
        0
      end

      # parent node in navigation/breadcrumb
      register_instance_option :parent do
        @parent_model ||= begin
          klass = abstract_model.model.superclass
          klass = nil if klass.to_s.in?(%w[Object BasicObject ActiveRecord::Base])
          klass
        end
      end

      register_instance_option :navigation_label do
        @navigation_label ||=
          if (parent_module = abstract_model.model.try(:module_parent) || abstract_model.model.try!(:parent)) != Object
            parent_module.to_s
          end
      end

      register_instance_option :navigation_icon do
        nil
      end

      register_instance_option :scope do
        abstract_model.scoped
      end

      register_instance_option :last_created_at do
        abstract_model.model.last.try(:created_at) if abstract_model.properties.detect { |c| c.name == :created_at }
      end

      # Act as a proxy for the base section configuration that actually
      # store the configurations.
      def method_missing(method_name, *args, &block)
        send(:base).send(method_name, *args, &block)
      end
    end
  end
end
