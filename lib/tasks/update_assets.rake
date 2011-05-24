require File.expand_path('../../rails_admin/tasks/update_assets', __FILE__)

namespace :rails_admin do
  desc "Update assets"
  task :update_assets do
    RailsAdmin::Tasks::UpdateAssets.new.invoke_all
  end
end

