require 'font-awesome-rails'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'kaminari'
require 'nested_form'
require 'rails'
require 'rails_admin'
require 'remotipart'
require 'safe_yaml'
require 'foundation-rails'

SafeYAML::OPTIONS[:suppress_warnings] = true
SafeYAML::OPTIONS[:default_mode] = :unsafe

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin
    initializer 'RailsAdmin precompile hook', group: :all do |app|
      app.config.assets.precompile += %w[
        rails_admin/rails_admin.js
        rails_admin/rails_admin.css
        rails_admin/jquery.colorpicker.js
        rails_admin/jquery.colorpicker.css
      ]
    end

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), '../tasks/*.rake')].each { |f| load f }
    end

    def self.express_admin_menu
      rails_admin_menu_items = []

      rails_admin_menu_items << OpenStruct.new(name: 'Dashboard', path: "rails_admin.dashboard_path")

      OpenStruct.new(name: 'Admin', items: rails_admin_menu_items)
    end

  end
end
