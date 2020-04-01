require 'rails_admin/extensions/controller_extension'

module RailsAdmin
  EXTENSIONS = [] # rubocop:disable Style/MutableConstant
  AUTHORIZATION_ADAPTERS = {} # rubocop:disable Style/MutableConstant
  AUDITING_ADAPTERS = {} # rubocop:disable Style/MutableConstant
  CONFIGURATION_ADAPTERS = {} # rubocop:disable Style/MutableConstant

  # Extend RailsAdmin
  #
  # The extension may define various adapters (e.g., for authorization) and
  # register those via the options hash.
  def self.add_extension(extension_key, extension_definition, options = {})
    options.assert_valid_keys(:authorization, :configuration, :auditing)

    EXTENSIONS << extension_key

    if options[:authorization]
      AUTHORIZATION_ADAPTERS[extension_key] = extension_definition::AuthorizationAdapter
    end

    if options[:configuration]
      CONFIGURATION_ADAPTERS[extension_key] = extension_definition::ConfigurationAdapter
    end

    if options[:auditing]
      AUDITING_ADAPTERS[extension_key] = extension_definition::AuditingAdapter
    end
  end

  # Setup all extensions for testing
  def self.setup_all_extensions
    (AUTHORIZATION_ADAPTERS.values + AUDITING_ADAPTERS.values).each do |klass|
      begin
        klass.setup if klass.respond_to? :setup
      rescue # rubocop:disable Lint/HandleExceptions, Style/RescueStandardError
        # ignore errors
      end
    end
  end
end
