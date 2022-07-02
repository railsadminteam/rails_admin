# frozen_string_literal: true

require 'kaminari'
require 'nested_form'
require 'rails'
require 'rails_admin'
require 'rails_admin/version'
require 'turbo-rails'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin

    attr_accessor :importmap

    config.action_dispatch.rescue_responses['RailsAdmin::ActionNotAllowed'] = :forbidden

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

    initializer 'RailsAdmin precompile hook', group: :all do |app|
      case RailsAdmin.config.asset_source
      when :sprockets
        app.config.assets.precompile += %w[
          rails_admin/application.js
          rails_admin/application.css
        ]
        app.config.assets.paths << RailsAdmin::Engine.root.join('src')
        require 'rails_admin/support/esmodule_preprocessor'
        Sprockets.register_preprocessor 'application/javascript', RailsAdmin::ESModulePreprocessor
      when :importmap
        self.importmap = Importmap::Map.new.draw(app.root.join('config/importmap.rails_admin.rb'))
      end
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
