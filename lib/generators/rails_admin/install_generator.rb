# frozen_string_literal: true

require 'rails/generators'
require File.expand_path('utils', __dir__)

module RailsAdmin
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    include Generators::Utils::InstanceMethods

    argument :_namespace, type: :string, required: false, desc: 'RailsAdmin url namespace'
    class_option :asset, type: :string, required: false, default: nil, desc: 'Asset delivery method [options: propshaft, sprockets, external]'
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
      when 'sprockets', 'propshaft'
        # RailsAdmin serves the bundle shipped in the gem; nothing to configure.
      when 'external'
        configure_for_external
      else
        raise "Unknown asset source: #{asset.inspect}. Use propshaft, sprockets or external."
      end
    end

  private

    def asset
      @asset ||= normalize_asset(options['asset'] || detect_asset)
    end

    def normalize_asset(value)
      case value.to_s
      when 'webpack', 'vite', 'shakapacker', 'jsbundling', 'cssbundling'
        display "[#{value}] builds its own assets; configuring :external", :yellow
        'external'
      when 'webpacker', 'importmap'
        display "[#{value}] is no longer supported; RailsAdmin ships a prebuilt bundle", :yellow
        detect_asset
      else
        value.to_s
      end
    end

    def detect_asset
      if defined?(Propshaft)
        'propshaft'
      elsif Rails.root.join('webpack.config.js').exist? || defined?(ViteRuby)
        'external'
      else
        'sprockets'
      end
    end

    def configure_for_external
      template 'rails_admin.js', 'app/javascript/rails_admin.js'
      @fa_font_path = 'rails_admin'
      template 'rails_admin.scss.erb', 'app/javascript/rails_admin.scss'
      say <<~INSTRUCTIONS, :yellow
        Add the `rails_admin` npm package, then wire app/javascript/rails_admin.js and
        app/javascript/rails_admin.scss into your build so they output
        app/assets/builds/rails_admin.js and app/assets/builds/rails_admin.css.
      INSTRUCTIONS
    end
  end
end
