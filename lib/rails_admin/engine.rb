require 'font-awesome-rails'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'kaminari'
require 'nested_form'
require 'rack-pjax'
require 'rails'
require 'rails_admin'
require 'remotipart'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin

    config.action_dispatch.rescue_responses['RailsAdmin::ActionNotAllowed'] = :forbidden

    initializer 'RailsAdmin precompile hook', group: :all do |app|
      app.config.assets.precompile += %w(
        rails_admin/rails_admin.js
        rails_admin/rails_admin.css
        rails_admin/jquery.colorpicker.js
        rails_admin/jquery.colorpicker.css
      )
    end

    initializer 'RailsAdmin setup middlewares' do |app|
      app.config.middleware.use ActionDispatch::Cookies
      app.config.middleware.use ActionDispatch::Flash
      if app.config.api_only
        app.config.session_store :cookie_store
        app.config.middleware.use ActionDispatch::Session::CookieStore, app.config.session_options
      end
      app.config.middleware.use Rack::MethodOverride
      app.config.middleware.use Rack::Pjax
    end

    initializer 'RailsAdmin reload config in development' do
      if Rails.application.config.cache_classes
        if defined?(ActiveSupport::Reloader)
          ActiveSupport::Reloader.before_class_unload do
            RailsAdmin::Config.reset_all_models
          end
          # else
          # For Rails 4 not implemented
        end
      end
    end

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), '../tasks/*.rake')].each { |f| load f }
    end
  end
end
