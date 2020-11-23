namespace :rails_admin do
  desc 'Install rails_admin'
  task :install do
    system 'rails g rails_admin:install'
  end

  desc 'Uninstall rails_admin'
  task :uninstall do
    system 'rails g rails_admin:uninstall'
  end

  desc 'CI env for Travis'
  task :prepare_ci_env do
    adapter = ENV['CI_DB_ADAPTER'] || 'sqlite3'
    database = ('sqlite3' == adapter ? 'db/development.sqlite3' : 'ci_rails_admin')

    configuration = {
      'test' => {
        'adapter' => adapter,
        'database' => database,
        'username' => 'postgresql' == adapter ? 'postgres' : '',
        'password' => '',
        'host' => 'localhost',
        'encoding' => 'utf8',
        'pool' => 5,
        'timeout' => 5000,
      },
    }

    filename = Rails.root.join('config/database.yml')

    File.open(filename, 'w') do |f|
      f.write(configuration.to_yaml)
    end
  end
end
