require 'rails'
require 'jquery-rails'
require 'remotipart'
require 'bootstrap-sass'
require 'kaminari'
require 'rails_admin'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin
    initializer "RailsAdmin precompile hook" do |app|
      app.config.assets.precompile += ['rails_admin/rails_admin.js', 'rails_admin/rails_admin.css', 'rails_admin/jquery.colorpicker.js', 'rails_admin/jquery.colorpicker.css']
    end
  end
end
