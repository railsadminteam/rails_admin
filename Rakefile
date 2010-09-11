# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'bundler'

Bundler::GemHelper.install_tasks
Rspec::Core::RakeTask.new(:spec)

desc 'Run RSpec code examples'
task :default => :spec
