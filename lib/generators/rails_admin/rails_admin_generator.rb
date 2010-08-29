module RailsAdmin
  class RailsAdminGenerator < Rails::Generators::Base
    namespace "rails_admin"
    source_root File.expand_path("../templates", __FILE__)

    desc "RailsAdmin"

    def check_for_devise
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
            invoke 'devise', ['user']
          end

        else
          invoke 'devise:install'
          invoke 'devise', ['user']
        end

      else
        puts "Please put gem 'devise' into your Gemfile"
      end
    end

  end
end
# unirii, brinco, obor, opera, kisself, tipogrf, uverturii.
