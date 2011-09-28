require 'rails'
require 'jquery-rails'
require 'less-rails-bootstrap'
require 'rails_admin'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin
  end
end
