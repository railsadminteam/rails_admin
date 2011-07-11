require 'rails_admin/engine'
require 'rails_admin/abstract_model'
require 'rails_admin/abstract_history'
require 'rails_admin/config'
require 'rails_admin/extension'
require 'rails_admin/extensions/cancan'
require 'rails_admin/support/csv_converter'
require 'rails_admin/support/core_extensions'

module RailsAdmin
  # Copy of initializer blocks for reset and reinitialization
  #
  # @see RailsAdmin.reset
  @initializers = []

  def self.authenticate_with(&block)
    ActiveSupport::Deprecation.warn("'#{self.name}.authenticate_with { }' is deprecated, use 'RailsAdmin.config{|c| c.authenticate_with { } instead", caller)
    self.config {|c| c.authenticate_with(&block) }
  end

  def self.authorize_with(*args, &block)
    ActiveSupport::Deprecation.warn("'#{self.name}.authorize_with { }' is deprecated, use 'RailsAdmin.config{|c| c.authorize_with { } instead", caller)
    self.config {|c| c.authorize_with(*args, &block) }
  end

  def self.current_user_method(&block)
    ActiveSupport::Deprecation.warn("'#{self.name}.current_user_method { }' is deprecated, use 'RailsAdmin.config{|c| c.current_user_method { } instead", caller)
    self.config {|c| c.current_user_method(&block) }
  end

  def self.configure_with(extension, &block)
    ActiveSupport::Deprecation.warn("'#{self.name}.configure_with { }' is deprecated, use 'RailsAdmin.config{|c| c.configure_with { } instead", caller)
    self.config {|c| c.configure_with(extension, &block) }
  end

  # Setup RailsAdmin
  #
  # Given the first argument is a model class, a model class name
  # or an abstract model object proxies to model configuration method.
  #
  # If only a block is passed, yields RailsAdmin::Config. The block will be
  # stored for resetting the engine before each request in development mode.
  #
  # Otherwise returns RailsAdmin::Config class.
  #
  # @see RailsAdmin::Config
  def self.config(entity = nil, &block)
    if entity
      RailsAdmin::Config.model(entity, &block)
    elsif block_given?
      @initializers << block
      yield RailsAdmin::Config
    else
      RailsAdmin::Config
    end
  end

  # Reset RailsAdmin configuration to defaults and then reapply all stored
  # initialization blocks.
  def self.reset
    RailsAdmin::Config.reset
    @initializers.clear.each {|block| self.config(&block)}
  end
end
