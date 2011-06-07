require 'rails_admin'
require 'rails'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin
    initializer "static assets" do |app|
      if app.config.serve_static_assets
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end
    end
  end
end
