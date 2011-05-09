require File.expand_path('../../rails_admin/tasks/update_assets', __FILE__)

namespace :rails_admin do
  desc "Update assets"
  task :update_assets do
    RailsAdmin::Tasks::UpdateAssets.run
  end
end

