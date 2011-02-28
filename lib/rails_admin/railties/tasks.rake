require 'rails_admin/railties/extratasks'
require 'pp'

namespace :admin do
  desc "Populate history tabel with a year of data"
  task :populate_history do
    RailsAdmin::ExtraTasks.populateDatabase
  end

  desc "Populate history tabel with a year of data"
  task :populate_database do
    system("rails generate dummy:data --base-amount 60 --growth-ratio 1.5")
    Rake::Task["dummy:data:import"].reenable
    Rake::Task["dummy:data:import"].invoke
  end

  desc "Copy assets files - javascripts, stylesheets and images"
  task :copy_assets do
    require 'rails/generators/base'
    origin      = File.join(RailsAdmin::Engine.root, "public")
    destination = File.join(Rails.root, "public")
    Rails::Generators::Base.source_root(origin)
    copier = Rails::Generators::Base.new
    %w( stylesheets images javascripts ).each do |directory|
      Dir[File.join(origin,directory,'rails_admin','**/*')].each do |file|
        relative  = file.gsub(/^#{origin}\//, '')
        dest_file = File.join(destination, relative)
        dest_dir  = File.dirname(dest_file)

        if !File.exist?(dest_dir)
          FileUtils.mkdir_p(dest_dir)
        end

        copier.copy_file(file, dest_file) unless File.directory?(file)
      end
    end
  end

  desc "Prepare Continuous Integration environment"
  task :prepare_ci_env do

    adapter = ENV["CI_DB_ADAPTER"] || "sqlite3"
    database = ENV["CI_DB_DATABASE"] || ("sqlite3" == adapter ? "db/development.sqlite3" : "ci_rails_admin")

    configuration = {
      "test" => {
        "adapter" => adapter,
        "database" => database,
        "username" => ENV["CI_DB_USERNAME"] || "rails_admin",
        "password" => ENV["CI_DB_PASSWORD"] || "rails_admin",
        "host" => ENV["CI_DB_HOST"] || "localhost",
        "encoding" => ENV["CI_DB_ENCODING"] || "utf8",
        "pool" => (ENV["CI_DB_POOL"] || 5).to_int,
        "timeout" => (ENV["CI_DB_TIMEOUT"] || 5000).to_int
      }
    }

    filename = Rails.root.join("config/database.yml")

    File.open(filename, "w") do |f|
      f.write(configuration.to_yaml)
    end
  end
end
