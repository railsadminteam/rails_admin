require 'rails/generators'
require File.expand_path('../utils', __FILE__)

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks

module RailsAdmin
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    include Rails::Generators::Migration
    include Generators::Utils::InstanceMethods
    extend Generators::Utils::ClassMethods

    argument :_model_name, :type => :string, :required => false, :desc => "Devise user model name"
    argument :_namespace, :type => :string, :required => false, :desc => "RailsAdmin url namespace"
    desc "RailsAdmin installation generator"

    def install
      routes = File.open(Rails.root.join("config/routes.rb")).try :read
      initializer = (File.open(Rails.root.join("config/initializers/rails_admin.rb")) rescue nil).try :read

      display "Hello, RailsAdmin installer will help you set things up!", :blue
      display "I need to work with Devise, let's look at a few things first:"
      display "Checking for a current installation of devise..."
      unless defined?(Devise)
        display "Adding devise gem to your Gemfile:"
        append_file "Gemfile", "\n", :force => true
        gem 'devise'
        Bundler.with_clean_env do
          run "bundle install"
        end
      else
        display "Found it!"
      end
      unless File.exists?(Rails.root.join("config/initializers/devise.rb"))
        display "Looks like you don't have devise installed! We'll install it for you:"
        generate "devise:install"
      else
        display "Looks like you've already installed it, good!"
      end

      namespace = ask_for("Where do you want to mount rails_admin?", "admin", _namespace)
      gsub_file "config/routes.rb", /mount RailsAdmin::Engine => \'\/.+\', :as => \'rails_admin\'/, ''
      route("mount RailsAdmin::Engine => '/#{namespace}', :as => 'rails_admin'")

      unless routes.index("devise_for")
        model_name = ask_for("What would you like the user model to be called?", "user", _model_name)
        display "Now setting up devise with user model name '#{model_name}':"
        generate "devise", model_name
      else
        display "And you already set it up, good! We just need to know about your user model name..."
        guess = routes.match(/devise_for +:(\w+)/)[1].try(:singularize)
        display("We found '#{guess}' (should be one of 'user', 'admin', etc.)")
        model_name = ask_for("Correct Devise model name if needed.", guess, _model_name)
        unless guess == model_name
          display "Now setting up devise with user model name '#{model_name}':"
          generate "devise", model_name
        else
          display "Ok, Devise looks already set up with user model name '#{model_name}':"
        end
      end
      display "Now you'll need an initializer..."
      @model_name = model_name
      unless initializer
        template "initializer.erb", "config/initializers/rails_admin.rb"
      else
        display "You already have a config file. You're updating, heh? I'm generating a new 'rails_admin.rb.example' that you can review."
        template "initializer.erb", "config/initializers/rails_admin.rb.example"
        config_tag = initializer.match(/RailsAdmin\.config.+\|(.+)\|/)[1] rescue nil
        if config_tag
          if initializer.index(::Regexp.new("#{config_tag}\.current_user_method.?\{.+?\}"))
            display "current_user_method found and updated with 'current_#{model_name}'", :green
            gsub_file Rails.root.join("config/initializers/rails_admin.rb"), ::Regexp.new("#{config_tag}\.current_user_method.?\{.+?\}"), "#{config_tag}.current_user_method { current_#{model_name} }"
          else
            display "current_user_method not found. Added one with 'current_#{model_name}'!", :yellow
            insert_into_file Rails.root.join("config/initializers/rails_admin.rb"), "\n\n  #{config_tag}.current_user_method { current_#{model_name} } #auto-generated", :after => /^RailsAdmin\.config.+$/
          end
        else
          display "Couldn't parse your config file: current_user_method couldn't be updated", :red
        end
      end
      display "Adding a migration..."
      migration_template 'migration.rb', 'db/migrate/create_rails_admin_histories_table.rb' rescue display $!.message
      display "Job's done: migrate, start your server and visit '/#{namespace}'!", :blue
    end
  end
end
