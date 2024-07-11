

namespace :rails_admin do
  desc 'Install rails_admin'
  task :install do
    system 'rails g rails_admin:install'
  end

  desc 'Uninstall rails_admin'
  task :uninstall do
    system 'rails g rails_admin:uninstall'
  end

  desc 'CI env for GitHub Actions'
  task :prepare_ci_env do
    adapter = ENV['CI_DB_ADAPTER'] || 'sqlite3'
    database = (adapter == 'sqlite3' ? 'db/development.sqlite3' : 'ci_rails_admin')
    username =
      case adapter
      when 'postgresql'
        'postgres'
      when 'mysql2'
        'root'
      else
        ''
      end

    configuration = {
      'test' => {
        'adapter' => adapter,
        'database' => database,
        'username' => username,
        'password' => (adapter == 'postgresql' ? 'postgres' : ''),
        'host' => '127.0.0.1',
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
