require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

begin
  require CI_ORM.to_s
  require "#{CI_ORM}/railtie"
rescue LoadError # rubocop:disable HandleExceptions
end

require 'active_storage/engine' if Rails.version >= '5.2.0' && CI_ORM == :active_record

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups, CI_ORM)

module DummyApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.eager_load_paths.reject! { |p| p =~ %r{/app/(\w+)$} && !%w(controllers helpers views).push(CI_ORM).include?(Regexp.last_match[1]) }
    config.autoload_paths += %W(#{config.root}/app/#{CI_ORM} #{config.root}/app/#{CI_ORM}/concerns #{config.root}/lib)
    config.i18n.load_path += Dir[Rails.root.join('app', 'locales', '*.{rb,yml}').to_s]
    config.active_record.raise_in_transactional_callbacks = true if Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 2 && CI_ORM == :active_record
    config.active_record.time_zone_aware_types = [:datetime, :time] if Rails::VERSION::MAJOR >= 5 && CI_ORM == :active_record
    config.active_record.sqlite3.represent_boolean_as_integer = true if CI_ORM == :active_record && config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer=)
    config.active_storage.service = :local if defined?(ActiveStorage)
  end
end
