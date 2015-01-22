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

module RailsAdmin
  module Config
    # Model specific configuration object.
    class Model
      include RailsAdmin::Config::Proxyable
      include RailsAdmin::Config::Configurable
      include RailsAdmin::Config::Hideable
      include RailsAdmin::Config::Sections

      attr_reader :abstract_model
      attr_accessor :groups
      attr_reader :parent, :root

      def initialize(entity)
        @parent = nil
        @root = self

        @abstract_model = begin
          if entity.is_a?(RailsAdmin::AbstractModel)
            entity
          elsif entity.is_a?(Class) || entity.is_a?(String) || entity.is_a?(Symbol)
            RailsAdmin::AbstractModel.new(entity)
          else
            RailsAdmin::AbstractModel.new(entity.class)
          end
        end
        @groups = [RailsAdmin::Config::Fields::Group.new(self, :default).tap { |g| g.label { I18n.translate('admin.form.basic_info') } }]
      end

      def excluded?
        @excluded ||= !RailsAdmin::AbstractModel.all.collect(&:model_name).include?(abstract_model.try(:model_name))
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
        (@label ||= {})[I18n.locale] ||= abstract_model.model.model_name.human(locale: I18n.locale)
      end

      register_instance_option :label_plural do
        (@label_plural ||= {})[I18n.locale] ||= abstract_model.model.model_name.human(count: Float::INFINITY, default: label.pluralize, locale: I18n.locale)
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
          klass = nil if klass.to_s.in?(%w(Object BasicObject ActiveRecord::Base))
          klass
        end
      end

      register_instance_option :navigation_label do
        @navigation_label ||= begin
          if (parent_module = abstract_model.model.parent) != Object
            parent_module.to_s
          end
        end
      end

      register_instance_option :navigation_icon do
        nil
      end

      # Act as a proxy for the base section configuration that actually
      # store the configurations.
      def method_missing(m, *args, &block)
        send(:base).send(m, *args, &block)
      end

      def inspect
        "#<#{self.class.name}[#{abstract_model.model.name}] #{
          instance_variables.collect do |v|
            value = instance_variable_get(v)
            if [:@parent, :@root].include? v
              if value.respond_to? :name
                "#{v}=#{value.name.inspect}"
              else
                "#{v}=#{value.class.name}"
              end
            else
              "#{v}=#{value.inspect}"
            end
          end.join(', ')
        }>"
      end
    end
  end
end
