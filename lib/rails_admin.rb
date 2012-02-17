require 'rails_admin/engine'
require 'rails_admin/abstract_model'
require 'rails_admin/config'
require 'rails_admin/extension'
require 'rails_admin/extensions/cancan'
require 'rails_admin/extensions/paper_trail'
require 'rails_admin/extensions/history'
require 'rails_admin/support/csv_converter'
require 'rails_admin/support/core_extensions'

module RailsAdmin
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
    elsif block_given? && ENV['SKIP_RAILS_ADMIN_INITIALIZER'] != "true"
      block.call(RailsAdmin::Config)
    else
      RailsAdmin::Config
    end
  end
end
