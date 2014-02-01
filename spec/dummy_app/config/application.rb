require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

begin
  require "#{CI_ORM}/railtie"
rescue LoadError
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env, CI_ORM)

module DummyApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.eager_load_paths.reject!{ |p| p =~ /\/app\/(\w+)$/ && !%w(controllers helpers views).push(CI_ORM).include?($1) }
    config.autoload_paths += %W(#{config.root}/app/#{CI_ORM} #{config.root}/app/#{CI_ORM}/concerns)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('app', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
