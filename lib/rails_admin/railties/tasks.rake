require 'rails_admin/railties/extratasks'


namespace :admin do
  desc "Populate history tabel with a year of data"
  task :populate_history do
    RailsAdmin::ExtraTasks.populateDatabase
  end
end