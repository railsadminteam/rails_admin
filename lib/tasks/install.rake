require File.expand_path('../tasks', __FILE__)

namespace :rails_admin do
  desc "Install rails_admin"
  task :install do
    RailsAdmin::ExtraTasks.install(ENV['model_name'] || 'user')
  end
end

