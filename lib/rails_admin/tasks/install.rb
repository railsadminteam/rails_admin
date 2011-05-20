require 'rails/generators'
require File.expand_path('assets_copier', File.dirname(__FILE__))

module RailsAdmin
  module Tasks
    class Install
      def initialize(model_name = 'user')
        @model_name = model_name
      end

      include AssetsCopier

      def copy_file(original, destination)
        copier.copy_file(original, destination)
      end

      def run
        puts <<-GREETING
Hello!
Rails_admin works with devise. Checking for a current installation of devise!
GREETING

        if defined?(Devise)
          check_for_devise_models
        else
          puts "Please put gem 'devise' into your Gemfile"
        end

        copy_locales_files
        copy_assets_files

        puts "Also you need a new migration. We'll generate it for you now."
        `rails g rails_admin:install_migrations`

        puts "Done."
      end

      private

      def check_for_devise_models
        devise_path = Rails.root.join("config/initializers/devise.rb")

        if File.exists?(devise_path)
          parse_route_files
        else
          puts "Looks like you don't have devise install! We'll install it for you!"
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
        puts <<-SET_DEVISE
Setting up devise for you!
======================================================
SET_DEVISE
        `rails g devise #{@model_name}`
      end

      def copy_locales_files
        print "Now copying locales files! "
        locales_path = gem_path + "/config/locales/*.yml"

        app_path = Rails.root.join("config/locales")

        app_path.mkdir unless File.directory?(app_path)

        puts
        Dir.glob(locales_path).each do |file|
          copier.copy_file file, File.join(app_path, File.basename(file))
        end

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
