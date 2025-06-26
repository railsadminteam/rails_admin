# frozen_string_literal: true

require 'rails_admin/engine'
require 'rails_admin/abstract_model'
require 'rails_admin/config'
require 'rails_admin/config/const_load_suppressor'
require 'rails_admin/extension'
require 'rails_admin/extensions/cancancan'
require 'rails_admin/extensions/pundit'
require 'rails_admin/extensions/paper_trail'
require 'rails_admin/support/csv_converter'
require 'rails_admin/support/hash_helper'
require 'yaml'

module RailsAdmin
  extend RailsAdmin::Config::ConstLoadSuppressor

  # Setup RailsAdmin
  #
  # Given the first argument is a model class, a model class name
  # or an abstract model object proxies to model configuration method.
  #
  # If only a block is passed it is stored to initializer stack to be evaluated
  # on first request in production mode and on each request in development. If
  # initialization has already occurred (in other words RailsAdmin.setup has
  # been called) the block will be added to stack and evaluated at once.
  #
  # Otherwise returns RailsAdmin::Config class.
  #
  # @see RailsAdmin::Config
  def self.config(entity = nil, &block)
    if entity
      RailsAdmin::Config.model(entity, &block)
    elsif block_given?
      RailsAdmin::Config::ConstLoadSuppressor.suppressing { yield(RailsAdmin::Config) }
    else
      RailsAdmin::Config
    end
  end

  # Backwards-compatible with safe_yaml/load when SafeYAML isn't available.
  # Evaluates available YAML loaders at boot and creates appropriate method,
  # so no conditionals are required at runtime.
  begin
    require 'safe_yaml/load'
    def self.yaml_load(yaml)
      SafeYAML.load(yaml)
    end
  rescue LoadError
    if YAML.respond_to?(:safe_load)
      def self.yaml_load(yaml)
        use_yaml_unsafe_load = if ActiveRecord::Base.respond_to?(:use_yaml_unsafe_load)
          # Note that this only works for Rails 6
          #   - Ref: https://github.com/rails/rails/blob/v6.1.7.6/activerecord/lib/active_record/coders/yaml_column.rb#L50-L56
          ActiveRecord::Base.use_yaml_unsafe_load
        elsif ActiveRecord.respond_to?(:use_yaml_unsafe_load)
          # Note that this only works for Rails 7
          #   - Ref: https://github.com/rails/rails/blob/v7.1.4.2/activerecord/lib/active_record/coders/yaml_column.rb#L16
          ActiveRecord.use_yaml_unsafe_load
        else
          raise LoadError.new "Unknown attributes needed for safe-loading of YAML. Please verify for the ActiveRecord config of `use_yaml_unsafe_load` and plug your implementation in here."
        end

        yaml_column_permitted_classes = if ActiveRecord::Base.respond_to?(:yaml_column_permitted_classes)
          # Note that this only works for Rails 6
          ActiveRecord::Base.yaml_column_permitted_classes
        elsif ActiveRecord.respond_to?(:yaml_column_permitted_classes)
          # Note that this only works for Rails 7
          ActiveRecord.yaml_column_permitted_classes
        else
          raise LoadError.new "Unknown attributes needed for safe-loading of YAML. Please verify for the ActiveRecord config of `yaml_column_permitted_classes` and plug your implementation in here."
        end

        if use_yaml_unsafe_load
          YAML.unsafe_load(yaml)
        elsif YAML.method(:safe_load).parameters.include?([:key, :permitted_classes])
          YAML.safe_load(yaml, permitted_classes: yaml_column_permitted_classes, aliases: true)
        else
          YAML.safe_load(yaml, yaml_column_permitted_classes, [], true)
        end
      end
    else
      raise LoadError.new "Safe-loading of YAML is not available. Please install 'safe_yaml' or install Psych 2.0+"
    end
  end

  def self.yaml_dump(object)
    YAML.dump(object)
  end
end
