require 'rails_admin'
require 'rails'

module RailsAdmin
  class Engine < Rails::Engine
    initializer "static assets" do |app|
      if app.config.serve_static_assets
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end
    end

    config.to_prepare do
      if @reset_rails_admin
        RailsAdmin.reset
      end
      @reset_rails_admin = true
    end
  end
end
