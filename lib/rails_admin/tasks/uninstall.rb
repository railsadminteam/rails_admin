require 'rails/generators'

module RailsAdmin
  module Tasks
    class Uninstall
      def self.run
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

        gem_file = Rails.root.join('Gemfile')
        if File.exists?(gem_file)
          puts "Removing rails_admin from Gemfile"
          lines = File.new(gem_file).readlines
          lines.each_with_index { |line, index| lines.delete_at(index) if line =~ /rails_admin/ }
          File.open(gem_file, "w") { |f| lines.each{|line| f.puts(line)} }
        end

        puts "Done. Sorry to see you go!\nYou can run 'rake db:migrate' to get rid of rails_admin table.\nDevise was left untouched.\nBye!"
      end
    end
  end
end
