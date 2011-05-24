require File.expand_path('base', File.dirname(__FILE__))

module RailsAdmin
  module Tasks
    class Uninstall < Base
      def generate_uninstall_migrations
        say "Creating uninstall migrations", :green
        `rails g rails_admin:uninstall_migrations`
      end

      def delete_rails_admin_initializer
        initializer = Rails.root.join("config/initializers/rails_admin.rb")
        if File.exists? initializer
          say 'Deleting rails_admin initializer', :green
          remove_file initializer
        end
      end

      def delete_locales
        say "Deleting locales", :green
        %w(bg da de en es fi fr lt lv pl pt-BR pt-PT ru sv tr uk).each do |locale|
          target = Rails.root.join("config/locales/rails_admin.#{locale}.yml")
          remove_file target if File.exists? target
        end
      end

      def uninstall_gem
        say "Uninstalling gem", :green
        `gem uninstall rails_admin`
      end

      def remove_rails_admin_from_gemfile
        gem_file = Rails.root.join('Gemfile')
        if File.exists?(gem_file)
          say "Removing rails_admin from Gemfile", :green
          lines = File.new(gem_file).readlines
          lines.each_with_index { |line, index| lines.delete_at(index) if line =~ /rails_admin/ }
          File.open(gem_file, "w") { |f| lines.each{|line| f.puts(line)} }
        end
        say "Done.", :green
      end
    end
  end
end
