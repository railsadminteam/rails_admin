# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'action_controller/railtie'
require 'action_mailer/railtie'

begin
  require CI_ORM.to_s
  require "#{CI_ORM}/railtie"
rescue LoadError
  # ignore errors
end

require 'active_storage/engine' if CI_ORM == :active_record
require 'action_text/engine' if CI_ORM == :active_record

case CI_ASSET
when :webpacker
  require 'webpacker'
else
  require "#{CI_ASSET}/railtie"
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups, CI_ORM)

module DummyApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.load_defaults Rails.version[0, 3]
    config.eager_load_paths.reject! { |p| p =~ %r{/app/([^/]+)} && !%W[controllers jobs locales mailers #{CI_ORM}].include?(Regexp.last_match[1]) }
    config.eager_load_paths += %W[#{config.root}/app/#{CI_ORM}/eager_loaded]
    config.autoload_paths += %W[#{config.root}/lib]
    config.i18n.load_path += Dir[Rails.root.join('app', 'locales', '*.{rb,yml}').to_s]
    config.active_record.time_zone_aware_types = %i[datetime time] if CI_ORM == :active_record
    config.active_storage.service = :local if defined?(ActiveStorage)
    config.active_storage.replace_on_assign_to_many = false if defined?(ActiveStorage) && ActiveStorage.version < Gem::Version.create('6.1')
  end
end
