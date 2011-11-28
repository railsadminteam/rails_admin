# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

Dir['lib/tasks/*.rake'].each { |rake| load rake }

require "rubygems"
require "bundler/setup"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

