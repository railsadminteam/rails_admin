require 'rails_admin'
require 'rails'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin

    ActionDispatch::Callbacks.before do
      RailsAdmin.setup
    end

    initializer "rails admin development mode" do |app|
      ActionDispatch::Callbacks.after do
        RailsAdmin.reset if !app.config.cache_classes && RailsAdmin.config.reload_between_requests
      end
    end
  end
end
