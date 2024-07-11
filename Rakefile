

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

Dir['lib/tasks/*.rake'].each { |rake| load rake }

require 'bundler'
Bundler::GemHelper.install_tasks

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

namespace :vendorize do
  desc 'Tasks for vendorizing assets'

  task :flatpickr do
    Dir.chdir(__dir__)
    flatpickr = File.read('node_modules/flatpickr/dist/flatpickr.js')
    locales = Dir.glob('node_modules/flatpickr/dist/l10n/*.js').map { |f| File.read(f) }
    File.write('vendor/assets/javascripts/rails_admin/flatpickr-with-locales.js', ([flatpickr] + locales).join("\n"))
  end
end
