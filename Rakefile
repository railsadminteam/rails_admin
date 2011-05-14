#!/usr/bin/env rake

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'bundler'
Bundler::GemHelper.install_tasks

Dir['lib/tasks/*.rake'].each { |rake| load rake }

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :doc do
  require 'yard'
  YARD::Rake::YardocTask.new do |task|
    task.files   = ['LICENSE.md', 'lib/**/*.rb']
    task.options = [
      '--protected',
      '--output-dir', 'doc/yard',
      '--markup', 'markdown',
    ]
  end
end
