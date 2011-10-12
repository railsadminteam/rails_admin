require 'rails'
require 'jquery-rails'
require 'sass-rails' # Waiting for https://github.com/thomas-mcdonald/bootstrap-sass/pull/4
require 'bootstrap-sass'
require 'rails_admin'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin
    initializer "RailsAdmin precompile hook" do |app|
      app.config.assets.precompile += ['rails_admin/rails_admin.js', 'rails_admin/rails_admin.css']
    end
  end
end
