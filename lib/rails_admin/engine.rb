require 'font-awesome-rails'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'kaminari'
require 'nested_form'
require 'rack-pjax'
require 'rails'
require 'rails_admin'
require 'remotipart'
require 'safe_yaml'

SafeYAML::OPTIONS[:suppress_warnings] = true
SafeYAML::OPTIONS[:default_mode] = :unsafe

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin

    config.action_dispatch.rescue_responses.merge!('RailsAdmin::ActionNotAllowed' => :forbidden)

    initializer 'RailsAdmin precompile hook', group: :all do |app|
      app.config.assets.precompile += %w(
        rails_admin/rails_admin.js
        rails_admin/rails_admin.css
        rails_admin/jquery.colorpicker.js
        rails_admin/jquery.colorpicker.css
      )
    end

    initializer 'RailsAdmin pjax hook' do |app|
      app.config.middleware.use Rack::Pjax
    end

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), '../tasks/*.rake')].each { |f| load f }
    end
  end
end
