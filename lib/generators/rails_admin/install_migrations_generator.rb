require 'rails/generators'
require 'rails/generators/migration'
require File.expand_path('../utils', __FILE__)

module RailsAdmin
  class InstallMigrationsGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    class << self
      include Generators::Utils
    end

    desc "RailsAdmin migrations Install"

    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_rails_admin_histories_table.rb' rescue p $!.message
    end
  end
end
