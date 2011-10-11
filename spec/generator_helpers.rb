module GeneratorHelpers

  def create_routes_file(devise_user = 'user', rails_admin_path = 'admin')
    File.open(File.join(destination_root, 'config', 'routes.rb'), 'w') do |f|
      f.puts "DummyApp::Application.routes.draw do"
      f.puts "  devise_for :#{devise_user}s" if devise_user
      f.puts "  mount RailsAdmin::Engine => '/#{rails_admin_path}', :as => 'rails_admin'" if rails_admin_path
      f.puts "  root :to => '/'"
      f.puts "end"
    end
  end

  def create_config_file(devise_user = 'user')
    File.open(File.join(destination_root, 'config', 'initializers', 'rails_admin.rb'), 'w') do |f|
      f.puts %{
        RailsAdmin.config do |config|
          config.current_user_method { current_#{devise_user} }
        end
      }
    end
  end

  def has_route?(route)
    File.open(File.join(destination_root, 'config', 'routes.rb')).read.index(route)
  end

  def has_config?(config)
    File.open(File.join(destination_root, 'config', 'initializers', 'rails_admin.rb')).read.index(config)
  end
end
