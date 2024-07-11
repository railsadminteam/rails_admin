

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
when :sprockets, :webpack
  require 'sprockets/railtie'
when :importmap
  require 'sprockets/railtie'
  require 'importmap-rails'
when :vite
  require 'vite_rails'
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
    config.eager_load_paths = (config.try(:all_eager_load_paths) || config.eager_load_paths).reject { |p| p =~ %r{/app/([^/]+)} && !%W[controllers jobs locales mailers #{CI_ORM}].include?(Regexp.last_match[1]) }
    config.eager_load_paths += %W[#{config.root}/app/eager_loaded]
    config.autoload_paths += %W[#{config.root}/lib]
    config.i18n.load_path += Dir[Rails.root.join('app', 'locales', '*.{rb,yml}').to_s]
    if CI_ORM == :active_record
      config.active_record.time_zone_aware_types = %i[datetime time]
      config.active_record.yaml_column_permitted_classes = [Symbol] if [ActiveRecord::Base, ActiveRecord].any? { |klass| klass.respond_to?(:yaml_column_permitted_classes=) }
    end
    config.active_storage.service = :local if defined?(ActiveStorage)
    config.active_storage.replace_on_assign_to_many = false if defined?(ActiveStorage) && ActiveStorage.version < Gem::Version.create('6.1')

    case CI_ASSET
    when :webpack
      config.assets.precompile += %w[rails_admin.js rails_admin.css]
    when :importmap
      config.assets.paths << RailsAdmin::Engine.root.join('src')
      config.assets.precompile += %w[rails_admin.js rails_admin.css]
      config.importmap.cache_sweepers << RailsAdmin::Engine.root.join('src')
    end

    initializer :ignore_unused_assets_path, after: :append_assets_path, group: :all do |app|
      case CI_ASSET
      when :webpack, :importmap
        app.config.assets.paths.delete(Rails.root.join('app', 'assets', 'javascripts').to_s)
      when :sprockets
        app.config.assets.paths.delete(Rails.root.join('app', 'assets', 'builds').to_s)
      end
    end
  end
end
