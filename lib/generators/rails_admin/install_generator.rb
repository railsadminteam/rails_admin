

require 'rails/generators'
require 'rails_admin/version'
require File.expand_path('utils', __dir__)

module RailsAdmin
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    include Generators::Utils::InstanceMethods

    argument :_namespace, type: :string, required: false, desc: 'RailsAdmin url namespace'
    class_option :asset, type: :string, required: false, default: nil, desc: 'Asset delivery method [options: webpacker, webpack, sprockets, importmap, vite]'
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
      when 'vite'
        configure_for_vite
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
      elsif Rails.root.join('webpack.config.js').exist?
        'webpack'
      elsif Rails.root.join('config/importmap.rb').exist?
        'importmap'
      elsif defined?(ViteRuby)
        'vite'
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
      # To work around https://github.com/railsadminteam/rails_admin/issues/3565
      add_package_json_field('resolutions', {'rails_admin/@fortawesome/fontawesome-free' => '^5.15.0'})
    end

    def configure_for_vite
      vite_source_code_dir = ViteRuby.config.source_code_dir
      run "yarn add rails_admin@#{RailsAdmin::Version.js} sass"
      template('rails_admin.vite.js', File.join(vite_source_code_dir, 'entrypoints', 'rails_admin.js'))
      @fa_font_path = '@fortawesome/fontawesome-free/webfonts'
      template('rails_admin.scss.erb', File.join(vite_source_code_dir, 'stylesheets', 'rails_admin.scss'))
    end

    def configure_for_webpack
      run "yarn add rails_admin@#{RailsAdmin::Version.js}"
      template 'rails_admin.js', 'app/javascript/rails_admin.js'
      webpack_config = File.join(destination_root, 'webpack.config.js')
      marker = %r{application: ["']./app/javascript/application.js["']}
      if File.exist?(webpack_config) && File.read(webpack_config) =~ marker
        insert_into_file 'webpack.config.js', %(,\n    rails_admin: "./app/javascript/rails_admin.js"), after: marker
      else
        say 'Add `rails_admin: "./app/javascript/rails_admin.js"` to the entry section in your webpack.config.js.', :red
      end
      setup_css({'build' => 'webpack --config webpack.config.js'})
    end

    def configure_for_importmap
      run "yarn add rails_admin@#{RailsAdmin::Version.js}"
      template 'rails_admin.js', 'app/javascript/rails_admin.js'
      require_relative 'importmap_formatter'
      add_file 'config/importmap.rails_admin.rb', ImportmapFormatter.new.format
      setup_css
    end

    def setup_css(additional_script_entries = {})
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
      add_package_json_field('scripts', additional_script_entries.merge({'build:css' => 'sass ./app/assets/stylesheets/rails_admin.scss:./app/assets/builds/rails_admin.css --no-source-map --load-path=node_modules'}), <<~INSTRUCTION)
        Taking 'build:css' as an example, if you're already have application.sass.css for the sass build, the resulting script would look like:
          sass ./app/assets/stylesheets/application.sass.scss:./app/assets/builds/application.css ./app/assets/stylesheets/rails_admin.scss:./app/assets/builds/rails_admin.css --no-source-map --load-path=node_modules
      INSTRUCTION
    end

    def add_package_json_field(name, entries, instruction = nil)
      display "Add #{name} to package.json"
      package = begin
        JSON.parse(File.read(File.join(destination_root, 'package.json')))
      rescue Errno::ENOENT, JSON::ParserError
        {}
      end
      if package[name] && (package[name].keys & entries.keys).any?
        say <<~MESSAGE, :red
          You need to merge "#{name}": #{JSON.pretty_generate(entries)} into the existing #{name} in your package.json.#{instruction && "\n#{instruction}"}
        MESSAGE
      else
        package[name] ||= {}
        entries.each do |entry, value|
          package[name][entry] = value
        end
        add_file 'package.json', "#{JSON.pretty_generate(package)}\n"
      end
    end
  end
end
