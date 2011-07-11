require 'rails_admin'
require 'rails'

module RailsAdmin
  class Engine < Rails::Engine
    initializer "static assets" do |app|
      if app.config.serve_static_assets
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end
    end

    ActionDispatch::Callbacks.before do
      RailsAdmin.setup
    end

    if Rails.env == "development"
      ActionDispatch::Callbacks.after do
        RailsAdmin.reset
      end
    end
  end
end
