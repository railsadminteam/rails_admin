module GeneratorHelpers

  ['devise', 'rails_admin'].each do |name|
    define_method("create_#{name}_initializer".to_sym) { FileUtils.touch File.join(destination_root, 'config', 'initializers', "#{name}.rb") }
  end

  def create_rails_folder_structure
    config_path = File.join(destination_root, 'config')
    FileUtils.mkdir config_path
    FileUtils.mkdir File.join(config_path, 'initializers')
    FileUtils.mkdir File.join(config_path, 'locales')
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
