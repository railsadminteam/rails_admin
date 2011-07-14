require 'rails_admin/engine'
require 'rails_admin/abstract_model'
require 'rails_admin/abstract_history'
require 'rails_admin/config'
require 'rails_admin/extension'
require 'rails_admin/extensions/cancan'
require 'rails_admin/support/csv_converter'
require 'rails_admin/support/core_extensions'

module RailsAdmin
  # Copy of initializer blocks for initialization
  #
  # @see RailsAdmin.setup
  @initializers = []

  # Whether or not the initializers have been run
  #
  # @see RailsAdmin.reset
  # @see RailsAdmin.setup
  @initialized = false

  def self.authenticate_with(&block)
    ActiveSupport::Deprecation.warn("'#{self.name}.authenticate_with { }' is deprecated, use 'RailsAdmin.config{|c| c.authenticate_with }' instead", caller)
    self.config {|c| c.authenticate_with(&block) }
  end

  def self.authorize_with(*args, &block)
    ActiveSupport::Deprecation.warn("'#{self.name}.authorize_with { }' is deprecated, use 'RailsAdmin.config{|c| c.authorize_with }' instead", caller)
    self.config {|c| c.authorize_with(*args, &block) }
  end

  def self.current_user_method(&block)
    ActiveSupport::Deprecation.warn("'#{self.name}.current_user_method { }' is deprecated, use 'RailsAdmin.config{|c| c.current_user_method }' instead", caller)
    self.config {|c| c.current_user_method(&block) }
  end

  def self.configure_with(extension, &block)
    ActiveSupport::Deprecation.warn("'#{self.name}.configure_with { }' is deprecated, use 'RailsAdmin.config{|c| c.configure_with }' instead", caller)
    self.config {|c| c.configure_with(extension, &block) }
  end

  # Setup RailsAdmin
  #
  # Given the first argument is a model class, a model class name
  # or an abstract model object proxies to model configuration method.
  #
  # If only a block is passed it is stored to initializer stack to be evaluated
  # on first request in production mode and on each request in development. If
  # initialization has already occured (in other words RailsAdmin.setup has
  # been called) the block will be added to stack and evaluated at once.
  #
  # Otherwise returns RailsAdmin::Config class.
  #
  # @see RailsAdmin::Config
  def self.config(entity = nil, &block)
    if entity
      RailsAdmin::Config.model(entity, &block)
    elsif block_given?
      @initializers << block
      block.call(RailsAdmin::Config) if @initialized
    else
      RailsAdmin::Config
    end
  end

  # Reset RailsAdmin configuration to defaults
  def self.reset
    RailsAdmin::Config.reset
    @initialized = false
  end

  # Apply all initializers stored on application startup
  def self.setup
    @initializers.each {|block| block.call(RailsAdmin::Config) } unless @initialized
    @initialized = true
  end

  # Reset RailsAdmin including initializers
  def self.test_reset!
    self.reset
    @initializers.clear
  end
end
