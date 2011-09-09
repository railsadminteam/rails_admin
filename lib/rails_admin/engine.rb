require 'rails_admin'
require 'rails'

module RailsAdmin
  class Engine < Rails::Engine
    isolate_namespace RailsAdmin
  end
end
