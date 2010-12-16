module RailsAdmin
  class InstallAdminGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :model_name, :type => :string, :default => 'user'

    desc "RailsAdmin Install"

    def check_for_devise
      puts "Hello!
Rails_admin works with devise. Checking for a current installation of devise!
"
      if defined?(Devise)
        check_for_devise_models
      else
        puts "Please put gem 'devise' into your Gemfile"
      end

      copy_locales_files

      puts "Also you need a new migration. We'll generate it for you now."
      invoke 'rails_admin:install_migrations'
    end

    private

    def check_for_devise_models
      # File.exists?
      devise_path =  FileUtils.pwd + "/config/initializers/devise.rb"

      if File.exists?(devise_path)
        parse_route_files
      else
        puts "Looks like you don't have devise install! We'll install it for you!"
        invoke 'devise:install'
        set_devise

      end
    end

    def parse_route_files
      # check if migrations exist
      app_path = Rails.public_path.split("/")
      app_path.delete_at(-1)
      app_path = app_path.join("/")
      routes_path = app_path + "/config/routes.rb"

      content = ""

      File.readlines(routes_path).each{|line|
        content += line
      }

      unless content.index("devise_for").nil?
        # there is a devise_for in routes => Do nothing
        puts "Great! You have devise installed and setup!"
      else
        puts "Great you have devise installed, but not set up!"
        set_devise
      end
    end

    def set_devise
      puts "Setting up devise for you!
======================================================"
      invoke 'devise', [model_name]
    end

    def copy_locales_files
      print "Now copying locales files! "
      gem_path = __FILE__
      gem_path = gem_path.split("/")

      gem_path = gem_path[0..-5]
      gem_path = gem_path.join("/")
      ###
      locales_path = gem_path + "/config/locales/*.yml"

      app_path = Rails.public_path.split("/")
      app_path.delete_at(-1)
      app_path = app_path.join("/")

      app_path = app_path + "/config/locales"

      unless File.directory?(app_path)
        FileUtils.mkdir app_path
      end

      Dir.glob(locales_path).each do |file|
        file_path = file.split("/")
        file_path = file_path[-1]
        FileUtils.copy_file(file, app_path + "/" + file_path)
        print "."
      end
      print "\n"

    end
  end

end
