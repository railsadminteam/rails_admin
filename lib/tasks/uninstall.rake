require File.expand_path('../extra_tasks', __FILE__)

namespace :rails_admin do
  desc "Uninstall rails_admin"
  task :uninstall do
    RailsAdmin::ExtraTasks.uninstall
  end
end

