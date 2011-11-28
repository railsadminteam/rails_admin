require 'rails/generators'
require File.expand_path('../utils', __FILE__)

module RailsAdmin
  class UninstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    include Generators::Utils::InstanceMethods
    extend Generators::Utils::ClassMethods
    source_root File.expand_path('../templates', __FILE__)

    desc "RailsAdmin uninstall"

    def uninstall
      display "Why you leaving so soon? :("
      migration_template 'drop.rb', 'db/migrate/drop_rails_admin_histories_table.rb'
      remove_file 'config/initializers/rails_admin.rb'
      remove_file 'config/initializers/rails_admin.rb.example'
      gsub_file "config/routes.rb", /mount RailsAdmin::Engine => \'\/.+\', :as => \'rails_admin\'/, ''
      display "Done! Devise has been left untouched."
    end
  end
end
