require 'rails_admin/engine'
require 'rails_admin/abstract_model'
require 'rails_admin/abstract_history'
require 'rails_admin/config'
require 'rails_admin/authorization_adapters/cancan_adapter'

module RailsAdmin
  class AuthenticationNotConfigured < StandardError; end

  # RailsAdmin is setup to try and authenticate with warden
  # If warden is found, then it will try to authenticate
  #
  # This is valid for custom warden setups, and also devise
  # If you're using the admin setup for devise, you should set RailsAdmin to use the admin
  #
  # By default, this will raise in any of the following environments
  #   * production
  #   * beta
  #   * uat
  #   * staging
  #
  # @see RailsAdmin.authenticate_with
  # @see RailsAdmin.authorize_with
  DEFAULT_AUTHENTICATION = Proc.new do
    warden = request.env['warden']
    if warden
      warden.authenticate!
    else
      if %w(production beta uat staging).include?(Rails.env)
        raise AuthenticationNotConfigured, "See RailsAdmin.authenticate_with or setup Devise / Warden"
      end
    end
  end

  DEFAULT_AUTHORIZE = Proc.new {}

  DEFAULT_CURRENT_USER = Proc.new do
    warden = request.env["warden"]
    if warden
      warden.user
    elsif respond_to?(:current_user)
      current_user
    else
      raise "See RailsAdmin.current_user_method or setup Devise / Warden"
    end
  end

  # Setup authentication to be run as a before filter
  # This is run inside the controller instance so you can setup any authentication you need to
  #
  # By default, the authentication will run via warden if available
  # and will run the default.
  #
  # If you use devise, this will authenticate the same as _authenticate_user!_
  #
  # @example Devise admin
  #   RailsAdmin.authenticate_with do
  #     authenticate_admin!
  #   end
  #
  # @example Custom Warden
  #   RailsAdmin.authenticate_with do
  #     warden.authenticate! :scope => :paranoid
  #   end
  #
  # @see RailsAdmin::DEFAULT_AUTHENTICATION
  def self.authenticate_with(&blk)
    @authenticate = blk if blk
    @authenticate || DEFAULT_AUTHENTICATION
  end

  # Setup authorization to be run as a before filter
  # This is run inside the controller instance so you can setup any authorization you need to.
  #
  # By default, there is no authorization.
  #
  # @example Custom
  #   RailsAdmin.authorize_with do
  #     redirect_to root_path unless warden.user.is_admin?
  #   end
  #
  # To use an authorization adapter, pass the name of the adapter. For example,
  # to use with CanCan[https://github.com/ryanb/cancan], pass it like this.
  #
  # @example CanCan
  #   RailsAdmin.authorize_with :cancan
  #
  # See the wiki[https://github.com/sferik/rails_admin/wiki] for more on authorization.
  #
  # @see RailsAdmin::DEFAULT_AUTHORIZE
  def self.authorize_with(adapter = nil, &blk)
    if adapter == :cancan
      @authorize = Proc.new { @authorization_adapter = AuthorizationAdapters::CanCanAdapter.new(self) }
    else
      @authorize = blk if blk
    end
    @authorize || DEFAULT_AUTHORIZE
  end

  # Setup a different method to determine the current user or admin logged in.
  # This is run inside the controller instance and made available as a helper.
  #
  # By default, _request.env["warden"].user_ or _current_user_ will be used.
  #
  # @example Custom
  #   RailsAdmin.current_user_method do
  #     current_admin
  #   end
  #
  # @see RailsAdmin::DEFAULT_CURRENT_USER
  def self.current_user_method(&blk)
    @current_user = blk if blk
    @current_user || DEFAULT_CURRENT_USER
  end

  # Setup RailsAdmin
  #
  # If a model class is provided as the first argument model specific
  # configuration is loaded and returned.
  #
  # Otherwise yields self for general configuration to be used in
  # an initializer.
  #
  # @see RailsAdmin::Config.load
  def self.config(entity = nil, &block)
    if not entity
      yield RailsAdmin::Config
    else
      RailsAdmin::Config.model(entity, &block)
    end
  end
end
