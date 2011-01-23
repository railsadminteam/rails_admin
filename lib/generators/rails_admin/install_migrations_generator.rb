require 'rails/generators'
require 'rails/generators/migration'

module RailsAdmin
  class InstallMigrationsGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        migration_number += 1
        migration_number.to_s
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_histories_table.rb' rescue p $!.message
      sleep 1 # ensure scripts have different timestamps
      migration_template 'rename.rb', 'db/migrate/rename_histories_to_rails_admin_histories.rb'
    end
  end
end
