require 'spec_helper'
require 'generators/rails_admin/install_generator'

RSpec.describe RailsAdmin::InstallGenerator, type: :generator do
  destination File.expand_path('../dummy_app/tmp/generator', __dir__)
  arguments ['admin']

  before do
    prepare_destination
    File.write(File.join(destination_root, 'package.json'), '{"license": "MIT"}')
    FileUtils.touch File.join(destination_root, 'Gemfile')
    FileUtils.mkdir_p(File.join(destination_root, 'config/initializers'))
    File.write(File.join(destination_root, 'config/routes.rb'), <<-RUBY.gsub(/^ {4}/, ''))
    Rails.application.routes.draw do
      # empty
    end
    RUBY
  end

  after do
    FileUtils.rm_rf(destination_root)
  end

  it 'mounts RailsAdmin as Engine and generates RailsAdmin Initializer' do
    Dir.chdir(destination_root) do
      run_generator
    end
    expect(destination_root).to have_structure {
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
          contains '@import "~rails_admin/src/rails_admin/styles/base"'
        end
      when :sprockets
        file 'Gemfile' do
          contains 'sassc-rails'
        end
      end
    }
  end

  it 'inserts asset_source option to RailsAdmin Initializer' do
    File.write(File.join(destination_root, 'config/initializers/rails_admin.rb'), <<-RUBY.gsub(/^ {4}/, ''))
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
