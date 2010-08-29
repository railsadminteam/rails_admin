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
  # other fields that would normally go in your gemspec
  # like authors, email and has_rdoc can also be included here
end

Rspec::Core::RakeTask.new(:spec)

task :default => :spec
