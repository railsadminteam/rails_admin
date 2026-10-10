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
require 'rails_admin/support/serialization_schema'

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

  # RailsAdmin's own deprecation warnings go through this, so an application can
  # configure or silence them independently. Registered as
  # +app.deprecators[:rails_admin]+ on Rails 7.1+.
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('5.0', 'RailsAdmin')
  end
end
