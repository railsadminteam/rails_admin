# frozen_string_literal: true

require 'rails/generators'
require 'rails_admin/version'
require File.expand_path('utils', __dir__)

module RailsAdmin
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    include Generators::Utils::InstanceMethods

    argument :_namespace, type: :string, required: false, desc: 'RailsAdmin url namespace'
    class_option :asset, type: :string, required: false, default: nil, desc: 'Asset delivery method [options: webpacker, sprockets, importmap]'
    desc 'RailsAdmin installation generator'

    def install
      if File.read(File.join(destination_root, 'config/routes.rb')).include?('mount RailsAdmin::Engine')
        display "Skipped route addition, since it's already there"
      else
        namespace = ask_for('Where do you want to mount rails_admin?', 'admin', _namespace)
        route("mount RailsAdmin::Engine => '/#{namespace}', as: 'rails_admin'")
      end
      if File.exist? File.join(destination_root, 'config/initializers/rails_admin.rb')
        insert_into_file 'config/initializers/rails_admin.rb', "  config.asset_source = :#{asset}\n", after: "RailsAdmin.config do |config|\n"
      else
        template 'initializer.erb', 'config/initializers/rails_admin.rb'
      end
      display "Using [#{asset}] for asset delivery method"
      case asset
      when 'webpack'
        configure_for_webpack
      when 'importmap'
        configure_for_importmap
      when 'webpacker'
        configure_for_webpacker5
      when 'sprockets'
        configure_for_sprockets
      else
        raise "Unknown asset source: #{asset}"
      end
    end

  private

    def asset
      return options['asset'] if options['asset']

      if defined?(Webpacker)
        'webpacker'
      elsif Rails.root.join('config/importmap.rb').exist?
        'importmap'
      else
        'sprockets'
      end
    end

    def configure_for_sprockets
      gem 'sassc-rails'
    end

    def configure_for_webpacker5
      run "yarn add rails_admin@#{RailsAdmin::Version.js}"
      template 'rails_admin.webpacker.js', 'app/javascript/packs/rails_admin.js'
      template 'rails_admin.scss.erb', 'app/javascript/stylesheets/rails_admin.scss'
    end

    def configure_for_webpack
      run "yarn add rails_admin@#{RailsAdmin::Version.js} css-loader mini-css-extract-plugin sass sass-loader"
      template 'rails_admin.js', 'app/javascript/rails_admin.js'
      template 'rails_admin.scss.erb', 'app/javascript/rails_admin.scss'
      template 'webpack.config.js', 'webpack.config.js'
    end

    def configure_for_importmap
      run "yarn add rails_admin@#{RailsAdmin::Version.js}"
      template 'rails_admin.js', 'app/javascript/rails_admin.js'
      require_relative 'importmap_formatter'
      add_file 'config/importmap.rails_admin.rb', ImportmapFormatter.new.format
      setup_css
    end

    def setup_css
      gem 'cssbundling-rails'
      rake 'css:install:sass'

      @fa_font_path = '.'
      template 'rails_admin.scss.erb', 'app/assets/stylesheets/rails_admin.scss'
      asset_config = %{Rails.application.config.assets.paths << Rails.root.join("node_modules/@fortawesome/fontawesome-free/webfonts")\n}
      if File.exist? File.join(destination_root, 'config/initializers/assets.rb')
        append_to_file 'config/initializers/assets.rb', asset_config
      else
        add_file 'config/initializers/assets.rb', asset_config
      end

      display 'Add build:css script'
      build_script = 'sass ./app/assets/stylesheets/rails_admin.scss:./app/assets/builds/rails_admin.css --no-source-map --load-path=node_modules'
      package = begin
        JSON.parse(File.read(File.join(destination_root, 'package.json')))
      rescue Errno::ENOENT, JSON::ParserError
        {}
      end
      if package['scripts'] && package['scripts']['build:css']
        say <<-MESSAGE.gsub(/^ {10}/, ''), :red
          Append or merge into existing "scripts": { "build:css": "#{build_script}" } to your package.json.
          For example, if you're already have application.sass.css for the sass build, the resulting script would look like:
            sass ./app/assets/stylesheets/application.sass.scss:./app/assets/builds/application.css ./app/assets/stylesheets/rails_admin.scss:./app/assets/builds/rails_admin.css --no-source-map --load-path=node_modules
        MESSAGE
      else
        package['scripts'] ||= {}
        package['scripts']['build:css'] = build_script
        add_file 'package.json', JSON.pretty_generate(package)
      end
    end
  end
end
