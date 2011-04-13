module GeneratorHelpers

  def create_rails_folder_structure
    config_path = File.join(destination_root, 'config')
    FileUtils.mkdir config_path
    FileUtils.mkdir File.join(config_path, 'initializers')
    FileUtils.mkdir_p File.join(destination_root, 'app', 'models')
  end

  def create_devise_initializer
    FileUtils.touch File.join(destination_root, 'config', 'initializers', 'devise.rb')
  end

  def create_routes_without_devise
    File.open(File.join(destination_root, 'config', 'routes.rb'), 'w') do |f|
      f.puts "DummyApp::Application.routes.draw do
        root :to => 'rails_admin::Main#index'
      end
"
    end
  end

  def create_routes_with_devise
    File.open(File.join(destination_root, 'config', 'routes.rb'), 'w') do |f|
      f.puts "DummyApp::Application.routes.draw do
        devise_for :users
        root :to => 'rails_admin::Main#index'
      end
"
    end
  end

end
