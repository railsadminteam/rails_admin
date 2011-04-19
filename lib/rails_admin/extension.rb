module RailsAdmin
  EXTENSIONS = []
  AUTHORIZATION_ADAPTERS = {}

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
