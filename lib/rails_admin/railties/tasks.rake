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
end