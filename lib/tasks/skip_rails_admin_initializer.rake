task :environment => :disable_rails_admin_initializer
task :disable_rails_admin_initializer do
  ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true' if ENV['SKIP_RAILS_ADMIN_INITIALIZER'].nil? 
end
