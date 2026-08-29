# frozen_string_literal: true

require 'kaminari'
require 'nested_form'
require 'rails'
require 'rails_admin'
require 'rails_admin/extensions/url_for_extension'
require 'rails_admin/version'
require 'turbo-rails'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin

    config.action_dispatch.rescue_responses['RailsAdmin::ActionNotAllowed'] = :forbidden

    initializer 'RailsAdmin load UrlForExtension' do
      RailsAdmin::Engine.routes.singleton_class.prepend(RailsAdmin::Extensions::UrlForExtension)
    end

    initializer 'RailsAdmin reload config in development' do |app|
      config.initializer_path = app.root.join('config/initializers/rails_admin.rb')

      unless Rails.application.config.cache_classes
        ActiveSupport::Reloader.before_class_unload do
          RailsAdmin::Config.reload!
        end

        reloader = app.config.file_watcher.new([config.initializer_path], []) do
          # Do nothing, ActiveSupport::Reloader will trigger class_unload! anyway
        end

        app.reloaders << reloader
        app.reloader.to_run do
          reloader.execute_if_updated { require_unload_lock! }
        end
        reloader.execute
      end
    end

    initializer 'RailsAdmin assets', group: :all do |app|
      next unless app.config.respond_to?(:assets)

      builds_path = RailsAdmin::Engine.root.join('app/assets/builds').to_s
      app.config.assets.paths << builds_path unless app.config.assets.paths.include?(builds_path)

      app.config.assets.precompile += %w[rails_admin.js rails_admin.css] if RailsAdmin.config.asset_source == :sprockets
    end

    # Check for required middlewares, users may forget to use them in Rails API mode
    config.after_initialize do |app|
      has_session_store = app.config.middleware.to_a.any? do |m|
        m.klass.try(:<=, ActionDispatch::Session::AbstractStore) ||
          m.klass.try(:<=, ActionDispatch::Session::AbstractSecureStore) ||
          m.klass.name =~ /^ActionDispatch::Session::/
      end
      loaded = app.config.middleware.to_a.map(&:name)
      required = %w[ActionDispatch::Cookies ActionDispatch::Flash Rack::MethodOverride]
      missing = required - loaded
      unless missing.empty? && has_session_store
        configs = missing.map { |m| "config.middleware.use #{m}" }
        configs << "config.middleware.use #{app.config.session_store.try(:name) || 'ActionDispatch::Session::CookieStore'}, #{app.config.session_options}" unless has_session_store
        raise <<~ERROR
          Required middlewares for RailsAdmin are not added
          To fix this, add

            #{configs.join("\n  ")}

          to config/application.rb.
        ERROR
      end

      RailsAdmin::Version.warn_with_js_version
    end
  end
end
