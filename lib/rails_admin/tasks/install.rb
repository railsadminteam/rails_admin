require File.expand_path('base', File.dirname(__FILE__))

module RailsAdmin
  module Tasks
    class Install < Base
      def initialize(model_name = 'user')
        @model_name = model_name
        super
      end

      def check_devise
        say "Hello!\nRails_admin works with devise. Checking for a current installation of devise!", :green

        if defined?(Devise)
          devise_path = Rails.root.join("config/initializers/devise.rb")
          if File.exists?(devise_path)
            parse_route_files
          else
            say "Looks like you don't have devise install! We'll install it for you!", :green
            `rails g devise:install`
            set_devise
          end
        else
          say "Please put gem 'devise' into your Gemfile(Devise must be required before RailsAdmin)", :yellow
          say "Aborting", :red
          exit 0
        end
      end

      def copy_locales_files
        say "Now copying locales files! ", :green
        locales_path = self.class.source_root + "/config/locales/*.yml"
        app_path = Rails.root.join("config/locales")
        app_path.mkdir unless File.directory?(app_path)

        puts
        Dir.glob(locales_path).each do |file|
          copy_file file, File.join(app_path, File.basename(file)), :verbose => true
        end

      end

      def copy_assets_files
        super({:verbose => true})
      end

      def generate_migration
        say "Also you need a new migration. We'll generate it for you now.", :green
        `rails g rails_admin:install_migrations`

        say "Done.", :green
      end

      private

      def parse_route_files
        routes_path = Rails.root.join("config/routes.rb")
        content = ""
        File.readlines(routes_path).each{|line| content += line }

        unless content.index("devise_for").nil?
          # there is a devise_for in routes => Do nothing
          say "Great! You have devise installed and setup!", :green
        else
          say "Great you have devise installed, but not set up!", :green
          set_devise
        end
      end

      def set_devise
        say "Setting up devise for you!\n#{'='*55}", :green
        `rails g devise #{@model_name}`
      end

    end
  end
end
