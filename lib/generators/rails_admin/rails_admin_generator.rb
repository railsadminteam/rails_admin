module RailsAdmin
  class RailsAdminGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    namespace "rails_admin"

    def print_instructions
      puts "RailsAdmin!
Hello, to install rails_admin into your app you need to run rails g rails_admin:install_admin"
    end

  end
end
