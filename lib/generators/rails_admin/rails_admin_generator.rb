module RailsAdmin
  class RailsAdminGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    namespace "rails_admin"

    def print_instructions
      puts "RailsAdmin!

Hello, to install rails_admin into your app you need to run:

  rake rails_admin:install

By default RailsAdmin works with Devise to provide authentication. If you use
Devise, but want use another model than the default 'user' you can provide the
custom model name as an argument:

  rails g rails_admin:install_migrations member

"
    end

  end
end
