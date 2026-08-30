# frozen_string_literal: true

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
        if CI_ASSET == :external
          file 'app/javascript/rails_admin.js' do
            contains 'import "rails_admin/src/rails_admin/base"'
          end
          file 'app/javascript/rails_admin.scss' do
            contains '$fa-font-path: "rails_admin";'
            contains '@import "rails_admin/src/rails_admin/styles/base"'
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

  describe 'asset_source normalization' do
    def initializer
      File.read(File.join(destination_root, 'config/initializers/rails_admin.rb'))
    end

    it 'treats --asset=webpack as :external' do
      Dir.chdir(destination_root) { run_generator %w[admin --asset=webpack --force] }
      expect(initializer).to include 'config.asset_source = :external'
      expect(destination_root).to(have_structure do
        file('app/javascript/rails_admin.js') { contains 'rails_admin/src/rails_admin/base' }
      end)
    end

    it 'writes :sprockets without generating an entrypoint' do
      Dir.chdir(destination_root) { run_generator %w[admin --asset=sprockets --force] }
      expect(initializer).to include 'config.asset_source = :sprockets'
      expect(File.exist?(File.join(destination_root, 'app/javascript/rails_admin.js'))).to be false
    end

    it 'falls back to a supported source for the removed --asset=importmap' do
      Dir.chdir(destination_root) { run_generator %w[admin --asset=importmap --force] }
      expect(initializer).to match(/config\.asset_source = :(propshaft|sprockets|external)\b/)
      expect(initializer).not_to include ':importmap'
    end
  end
end
