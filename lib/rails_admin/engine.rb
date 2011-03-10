require "rails_admin"
require "rails"

module RailsAdmin
  class Engine < Rails::Engine
    initializer "static assets" do |app|

      # If assets were copied for app's public/ folder, e.g. via rake admin:copy_assets, then don't insert the static
      # asset server, as it iterferes with Rails's own asset server.
      if app.config.serve_static_assets &&
         !(%w(stylesheets images javascripts).any?{|cat| File.exists?(File.join(Rails.root,'public',cat,'rails_admin'))})
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end
    end
    
    rake_tasks do
      load "rails_admin/railties/tasks.rake"
    end
  end
end
