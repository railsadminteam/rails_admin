require File.expand_path('../../rails_admin/tasks/install', __FILE__)

namespace :rails_admin do
  desc "Install rails_admin"
  task :install do
    RailsAdmin::Tasks::Install.run(ENV['model_name'] || 'user')
  end

  desc "Copy only locale files (part of install, but useful for deployments when only assets are needed)"
  task :copy_locales do
    RailsAdmin::Tasks::Install.copy_locales_files
  end

  desc "Copy only app/view files"
  task :copy_views do
    RailsAdmin::Tasks::Install.copy_view_files
  end
end
