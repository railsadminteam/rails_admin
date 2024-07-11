

require 'spec_helper'
require 'generators/rails_admin/install_generator'

RSpec.describe RailsAdmin::InstallGenerator, type: :generator do
  destination File.expand_path('../dummy_app/tmp/generator', __dir__)
  arguments ['admin', "--asset=#{CI_ASSET}", '--force']

  before do
    prepare_destination
    File.write(File.join(destination_root, 'package.json'), '{"license": "MIT"}')
    FileUtils.touch File.join(destination_root, 'Gemfile')
    FileUtils.mkdir_p(File.join(destination_root, 'config/initializers'))
    File.write(File.join(destination_root, 'config/routes.rb'), <<~RUBY)
      Rails.application.routes.draw do
        # empty
      end
    RUBY
    File.write(File.join(destination_root, 'Rakefile'), <<-RUBY.gsub(/^ {4}/, ''))
    desc 'Stub for testing'
    task 'css:install:sass'
    RUBY
  end

  after do
    FileUtils.rm_rf(destination_root)
  end

  it 'mounts RailsAdmin as Engine and generates RailsAdmin Initializer' do
    Dir.chdir(destination_root) do
      run_generator
    end
    expect(destination_root).to(
      have_structure do
        directory 'config' do
          directory 'initializers' do
            file 'rails_admin.rb' do
              contains 'RailsAdmin.config'
              contains 'asset_source ='
            end
          end
          file 'routes.rb' do
            contains "mount RailsAdmin::Engine => '/admin', as: 'rails_admin'"
          end
        end
        case CI_ASSET
        when :webpacker
          file 'app/javascript/packs/rails_admin.js' do
            contains 'import "rails_admin/src/rails_admin/base"'
          end
          file 'app/javascript/stylesheets/rails_admin.scss' do
            contains '@import "rails_admin/src/rails_admin/styles/base"'
          end
        when :sprockets
          file 'Gemfile' do
            contains 'sassc-rails'
          end
        when :importmap
          file 'app/javascript/rails_admin.js' do
            contains 'import "rails_admin/src/rails_admin/base"'
          end
          file 'app/assets/stylesheets/rails_admin.scss' do
            contains '$fa-font-path: ".";'
            contains '@import "rails_admin/src/rails_admin/styles/base"'
          end
          file 'config/importmap.rails_admin.rb' do
            contains 'pin "rails_admin", preload: true'
            contains 'pin "rails_admin/src/rails_admin/base", to: "https://ga.jspm.io/npm:rails_admin@'
            contains 'pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@'
          end
          file 'config/initializers/assets.rb' do
            contains 'Rails.root.join("node_modules/@fortawesome/fontawesome-free/webfonts")'
          end
          file 'package.json' do
            contains 'sass ./app/assets/stylesheets/rails_admin.scss:./app/assets/builds/rails_admin.css'
          end
        when :webpack
          file 'app/javascript/rails_admin.js' do
            contains 'import "rails_admin/src/rails_admin/base"'
          end
          file 'app/assets/stylesheets/rails_admin.scss' do
            contains '$fa-font-path: ".";'
            contains '@import "rails_admin/src/rails_admin/styles/base"'
          end
          file 'package.json' do
            contains 'webpack --config webpack.config.js'
            contains 'sass ./app/assets/stylesheets/rails_admin.scss:./app/assets/builds/rails_admin.css'
          end
        when :vite
          file 'app/frontend/entrypoints/rails_admin.js' do
            contains 'import "~/stylesheets/rails_admin.scss"'
            contains 'import "rails_admin/src/rails_admin/base"'
          end
          file 'app/frontend/stylesheets/rails_admin.scss' do
            contains '$fa-font-path: "@fortawesome/fontawesome-free/webfonts";'
            contains '@import "rails_admin/src/rails_admin/styles/base"'
          end
          file 'package.json' do
            contains 'sass'
          end
        end
      end,
    )
  end

  it 'inserts asset_source option to RailsAdmin Initializer' do
    File.write(File.join(destination_root, 'config/initializers/rails_admin.rb'), <<~RUBY)
      RailsAdmin.config do |config|
        # empty
      end
    RUBY
    Dir.chdir(destination_root) do
      run_generator
    end
    expect(File.read(File.join(destination_root, 'config/initializers/rails_admin.rb'))).to include 'config.asset_source ='
  end
end
