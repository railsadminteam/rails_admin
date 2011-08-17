require File.expand_path('../../rails_admin/tasks/uninstall', __FILE__)

namespace :rails_admin do
  desc "Uninstall rails_admin"
  task :uninstall do
    RailsAdmin::Tasks::Uninstall.run
  end
end
