require File.expand_path('../../rails_admin/tasks/install', __FILE__)

namespace :rails_admin do
  desc "Install rails_admin"
  task :install do
    RailsAdmin::Tasks::Install.new(ENV['model_name'] || 'user').invoke_all
  end
end

