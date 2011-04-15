module RailsAdmin
  EXTENSIONS = []
  AUTHORIZATION_ADAPTERS = {}

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

  # Extend RailsAdmin
  #
  # The extension may define various adapters (e.g., for authorization) and
  # register those via the options hash.
  def self.add_extension(extension_key, extension_definition, options = {})
    options.assert_valid_keys(:authorization)

    EXTENSIONS << extension_key

    if(authorization = options[:authorization])
      AUTHORIZATION_ADAPTERS[extension_key] = extension_definition::AuthorizationAdapter
    end
  end
end
