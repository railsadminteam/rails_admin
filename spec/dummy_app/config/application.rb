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
when :propshaft
  require 'propshaft'
when :sprockets, :external
  require 'sprockets/railtie'
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
    (CI_TARGET_ORMS - [CI_ORM]).each { |orm| config.paths.add "app/#{orm}", eager_load: false }
    config.eager_load_paths = (config.try(:all_eager_load_paths) || config.eager_load_paths).reject { |p| p =~ %r{/app/([^/]+)} && !%W[controllers jobs locales mailers #{CI_ORM}].include?(Regexp.last_match[1]) }
    config.eager_load_paths += %W[#{config.root}/app/eager_loaded]
    config.autoload_paths += %W[#{config.root}/lib]
    config.i18n.load_path += Dir[Rails.root.join('app', 'locales', '*.{rb,yml}').to_s]
    if CI_ORM == :active_record
      config.active_record.time_zone_aware_types = %i[datetime time]
      config.active_record.yaml_column_permitted_classes = [Symbol] if [ActiveRecord::Base, ActiveRecord].any? { |klass| klass.respond_to?(:yaml_column_permitted_classes=) }
    end
    config.active_storage.service = :local if defined?(ActiveStorage)

    if CI_ASSET == :external
      # The dummy app builds rails_admin.{js,css} into app/assets/builds, like a
      # jsbundling/cssbundling app would.
      config.assets.paths << Rails.root.join('app/assets/builds').to_s
      config.assets.precompile += %w[rails_admin.js rails_admin.css]
    end
  end
end
