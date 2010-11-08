# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
namespace :spec do
  desc "Run all examples using rcov"
  RSpec::Core::RakeTask.new(:rcov => :cleanup_rcov_files) do |task|
    task.rcov = true
    task.rcov_opts = %[-Ilib -Ispec --exclude ".bundler/*,gems/*,features,specs" --text-report --sort coverage]
  end
end

task :cleanup_rcov_files do
  rm_rf 'coverage'
end

task :default => ["spec:rcov"]
