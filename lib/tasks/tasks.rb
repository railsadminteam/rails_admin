module RailsAdmin
  class ExtraTasks

    class << self

      def install(model_name = 'user')
        @@model_name = model_name
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
        puts "Setting up devise for you!
  ======================================================"
        `rails g devise #{@@model_name}`
      end

      def copy_locales_files
        print "Now copying locales files! "
        gem_path = __FILE__
        gem_path = gem_path.split("/")

        gem_path = gem_path[0..-4]
        gem_path = gem_path.join("/")
        ###
        locales_path = gem_path + "/config/locales/*.yml"

        app_path = Rails.root.join("config/locales")

        unless File.directory?(app_path)
          app_path.mkdir
        end

        Rails::Generators::Base.source_root(gem_path)
        copier = Rails::Generators::Base.new
        puts ""
        Dir.glob(locales_path).each do |file|
          copier.copy_file file, File.join(app_path, File.basename(file))
        end

      end

    end

    def self.uninstall

      puts "Creating uninstall migrations"
      `rails g rails_admin:uninstall_migrations`

      initializer = Rails.root.join("config/initializers/rails_admin.rb")
      if File.exists? initializer
        puts "Deleting rails_admin initializer"
        FileUtils.rm(initializer)
      end

      puts "Deleting locales"
      %w(bg da de en es fi fr lt lv pl pt-BR pt-PT ru sv tr uk).each do |locale|
        target = Rails.root.join("config/locales/rails_admin.#{locale}.yml")
        FileUtils.rm(target) if File.exists? target
      end

      puts "Uninstalling gem"
      `gem uninstall rails_admin`

      gem_file = Rails.root.join('Gemfile')
      if File.exists?(gem_file)
        puts "Removing rails_admin from Gemfile"
        lines = File.new(gem_file).readlines
        lines.each_with_index { |line, index| lines.delete_at(index) if line =~ /rails_admin/ }
        File.open(gem_file, "w") { |f| lines.each{|line| f.puts(line)} }
      end

      puts "Done."
    end
  end
end
