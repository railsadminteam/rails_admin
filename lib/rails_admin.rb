require 'rubygems'
require 'bundler'

Bundler.setup

module RailsAdmin
  require 'rails_admin/engine' if defined?(Rails)
end
