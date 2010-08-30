# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = "rails_admin"
  gem.summary = "RailsAdmin for Rails 3"
  gem.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*"]
  gem.authors = ["Erik Michaels-Ober", "Bogdan Gaza"]
  gem.email = "sferik@gmail.com"
  gem.description = "RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data."
  gem.homepage = "http://github.com/sferik/rails_admin"
  gem.add_dependency("rails", "~> 3.0.0")
  gem.add_dependency("builder", "~> 2.1.0")
  gem.add_dependency("devise", "~> 1.1.0")
  gem.add_development_dependency("dummy_data", ">= 0.9")
  gem.add_development_dependency("jeweler", ">= 1.4.0")
  gem.add_development_dependency("rspec-rails", ">= 2.0.0.beta.20")
  gem.add_development_dependency("sqlite3-ruby", ">= 1.3.1")
end

Rspec::Core::RakeTask.new(:spec)

task :default => :spec
