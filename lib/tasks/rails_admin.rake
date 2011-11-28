task :environment => :disable_rails_admin_initializer

task :disable_rails_admin_initializer do
  ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true' if ENV['SKIP_RAILS_ADMIN_INITIALIZER'].nil?
end

namespace :rails_admin do
  desc "Install rails_admin"
  task :install do
    system 'rails g rails_admin:install'
  end

  desc "Uninstall rails_admin"
  task :uninstall do
    system 'rails g rails_admin:uninstall'
  end
end

