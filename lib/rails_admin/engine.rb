require "rails_admin"
require "rails"

module RailsAdmin
  class Engine < Rails::Engine
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

    rake_tasks do
      load "rails_admin/railties/tasks.rake"
    end
  end
end
