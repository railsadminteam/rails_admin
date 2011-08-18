require 'rails/generators'

module RailsAdmin
  module Tasks
    class Install
      class << self

        def run(model_name = 'user')
          @@model_name = model_name
          puts "Hello!
    Rails_admin works with devise. Checking for a current installation of devise!
    "
          if defined?(Devise)
            check_for_devise_models
          else
            puts "Please put gem 'devise' into your Gemfile"
          end

          create_route

          puts "Also you need a new migration. We'll generate it for you now."
          `rails g rails_admin:install_migrations`

          puts "Done."
        end

        def copy_locales_files
          print "Now copying locales files! "
          locales_path = gem_path + "/config/locales/*.yml"

          app_path = Rails.root.join("config/locales")

          unless File.directory?(app_path)
            app_path.mkdir
          end

          puts
          Dir.glob(locales_path).each do |file|
            copier.copy_file file, File.join(app_path, File.basename(file))
          end
        end

        def copy_view_files
          print "Now copying view files "
          origin = File.join(gem_path, 'app/views')
          destination = Rails.root.join('app/views')
          puts copy_files(%w( layouts . ), origin, destination)
        end

        def create_route
          print "Now creating rails_admin route\n"
          `rails g rails_admin:install_route`
        end

        private

        def copy_files(directories, origin, destination)
          directories.each do |directory|
            Dir[File.join(origin, directory, 'rails_admin', '**/*')].each do |file|
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

        def check_for_devise_models
          devise_path = Rails.root.join("config/initializers/devise.rb")

          if File.exists?(devise_path)
            parse_route_files
          else
            puts "Looks like you don't have devise installed! We'll install it for you!"
            `rails g devise:install`
            set_devise
          end
        end

        def parse_route_files
          routes_path = Rails.root.join("config/routes.rb")

          content = ""

          File.readlines(routes_path).each{|line| content += line }

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
          `rails g devise #{@@model_name}`
        end

        def gem_path
          File.expand_path('../../..', File.dirname(__FILE__))
        end

        def copier
          unless @copier
            Rails::Generators::Base.source_root(gem_path)
            @copier = Rails::Generators::Base.new
          end
          @copier
        end
      end
    end
  end
end
