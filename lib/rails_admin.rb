require 'rails_admin/engine'
require 'rails_admin/abstract_model'

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
  # This is run inside the controller instance so you can setup any authorization you need to
  #
  # By default, there is no authorization.
  #
  # @example Custom
  #   RailsAdmin.authorize_with do
  #     warden.user.is_admin?
  #   end
  #
  # @see RailsAdmin::DEFAULT_AUTHORIZE
  def self.authorize_with(&blk)
    @authorize = blk if blk
    @authorize || DEFAULT_AUTHORIZE
  end

end

