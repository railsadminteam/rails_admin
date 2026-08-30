# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

Dir['lib/tasks/*.rake'].each { |rake| load rake }

require 'bundler'
Bundler::GemHelper.install_tasks

# Abort `rake release` if the committed assets in app/assets/builds are stale.
Rake::Task['release:guard_clean'].enhance(['rails_admin:verify_assets'])

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task test: :spec

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  desc 'Run RuboCop'
  task :rubocop do
    warn 'Rubocop is disabled'
  end
end

task default: %i[spec rubocop]
