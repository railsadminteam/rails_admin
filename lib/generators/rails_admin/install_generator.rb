require 'rails/generators'
require 'rails_admin/version'
require File.expand_path('utils', __dir__)

module RailsAdmin
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    include Generators::Utils::InstanceMethods

    argument :_namespace, type: :string, required: false, desc: 'RailsAdmin url namespace'
    class_option :asset, type: :string, required: false, default: nil, desc: 'Asset delivery method [options: webpack, webpacker, sprockets]'
    desc 'RailsAdmin installation generator'

    def install
      namespace = ask_for('Where do you want to mount rails_admin?', 'admin', _namespace)
      route("mount RailsAdmin::Engine => '/#{namespace}', as: 'rails_admin'")
      if File.exist? File.join(destination_root, 'config/initializers/rails_admin.rb')
        insert_into_file 'config/initializers/rails_admin.rb', "  config.asset_source = :#{asset}\n", after: "RailsAdmin.config do |config|\n"
      else
        template 'initializer.erb', 'config/initializers/rails_admin.rb'
      end
      display "Using [#{asset}] for asset delivery method"
      case asset
      when 'webpack'
        configure_for_webpack
      when 'webpacker'
        configure_for_webpacker5
      when 'sprockets'
        configure_for_sprockets
      end
    end

  private

    def asset
      return options['asset'] if options['asset']

      if Rails.root.join('webpack.config.js').exist?
        'webpack'
      elsif defined?(Webpacker)
        'webpacker'
      else
        'sprockets'
      end
    end

    def configure_for_sprockets
      gem 'sassc-rails'
    end

    def configure_for_webpacker5
      run "yarn add rails_admin@#{RailsAdmin::Version.js}"
      @scss_relative_dir = '../stylesheets/'
      template 'rails_admin.js.erb', 'app/javascript/packs/rails_admin.js'
      template 'rails_admin.scss', 'app/javascript/stylesheets/rails_admin.scss'
      template 'environment.js', 'config/webpack/environment.js'
    end

    def configure_for_webpack
      run "yarn add rails_admin@#{RailsAdmin::Version.js} css-loader mini-css-extract-plugin sass sass-loader"
      @scss_relative_dir = './'
      template 'rails_admin.js.erb', 'app/javascript/rails_admin.js'
      template 'rails_admin.scss', 'app/javascript/rails_admin.scss'
      template 'webpack.config.js', 'webpack.config.js'
    end
  end
end
