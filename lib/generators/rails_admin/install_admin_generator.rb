module RailsAdmin
  class InstallAdminGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "RailsAdmin"
    
    def check_for_devise
      puts "Hello!
Rails_admin works with devise. Checking for a current installation of devise!
"
      loaded_gems = Bundler.setup.gems
      is_loaded = loaded_gems.reject{|t| t.name == "devise" ? false : true }.size == 1 ? true : false
      
      if is_loaded
        #File.exists?
        devise_path =  FileUtils.pwd + "/config/initializers/devise.rb"
        
        if File.exists?(devise_path)
          # check if migrations exist
          app_path = Rails.public_path.split("/")
          app_path.delete_at(-1)
          app_path = app_path.join("/")
          ###
          routes_path = app_path + "/config/routes.rb"
          
          content = ""
          
          File.readlines(routes_path).each{|line|
            content += line
          }
          
          unless content.index("devise_for").nil?
            # there is a devise_for in routes => Do nothing
            puts "Great! You have devise installed and setup!"
          else
            puts "Great you have devise installed, but not set up!
Setting up devise for you!
======================================================"
            invoke 'devise', ['user']
          end
          
        else
          puts "Looks like you don't have devise install! We'll install it for you!"
          puts "Installing devise!
======================================================"
          invoke 'devise:install'
          
          puts "Setting up devise for you!
======================================================"
          invoke 'devise', ['user']
        end
        
      else
        puts "Please put gem 'devise' into your Gemfile"
      end
      
      puts "Also you need a new migration. We'll generate it for you or you can generate it manually using rails g rails_admin:install_migrations"
      invoke 'rails_admin:install_migrations'
    end
    
  end
end