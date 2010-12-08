require 'rails_admin/railties/extratasks'

namespace :admin do
  desc "Populate history tabel with a year of data"
  task :populate_history do
    RailsAdmin::ExtraTasks.populateDatabase
  end

  desc "Populate history tabel with a year of data"
  task :populate_database do
    system("rails generate dummy:data --base-amount 60 --growth-ratio 1.5")
    Rake::Task["dummy:data:import"].reenable
    Rake::Task["dummy:data:import"].invoke
  end

  desc "Copy assets files - javascripts, stylesheets and images"
  task :copy_assets do
    #require 'rails/generators/base'
    origin      = File.join(RailsAdmin::Engine.root, "public")
    destination = File.join(Rails.root, "public")
    Rails::Generators::Base.source_root(origin)
    copier = Rails::Generators::Base.new
    %w( stylesheets images javascripts ).each do |directory|
      Dir[File.join(origin,directory,'rails_admin','*')].each do |file|
        relative = file.gsub(/^#{origin}\//, '')
        copier.copy_file(file, File.join(destination,relative))
      end
    end
  end
end
