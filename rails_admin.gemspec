# frozen_string_literal: true

require_relative 'lib/rails_admin/version'

Gem::Specification.new do |spec|
  # If you add a dependency, please maintain alphabetical order
  spec.add_dependency 'activemodel-serializers-xml', '>= 1.0'
  spec.add_dependency 'csv'
  spec.add_dependency 'kaminari', '>= 0.14', '< 2.0'
  spec.add_dependency 'nested_form', '~> 0.3'
  spec.add_dependency 'rails', ['>= 7.0', '< 9']
  spec.add_dependency 'turbo-rails', ['>= 1.0', '< 3']
  spec.add_development_dependency 'bundler', '>= 1.0'
  spec.authors = ['Erik Michaels-Ober', 'Bogdan Gaza', 'Petteri Kaapa', 'Benoit Benezech', 'Mitsuhiro Shibuya']
  spec.description = 'RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.'
  spec.email = ['sferik@gmail.com', 'bogdan@cadmio.org', 'petteri.kaapa@gmail.com']
  spec.files = Dir['Gemfile', 'LICENSE.md', 'README.md', 'Rakefile', 'package.json', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*', 'src/**/*', 'vendor/**/*']
  spec.licenses = %w[MIT]
  spec.homepage = 'https://github.com/railsadminteam/rails_admin'
  spec.name = 'rails_admin'
  spec.require_paths = %w[lib]
  spec.required_ruby_version     = '>= 2.7.0'
  spec.required_rubygems_version = '>= 1.8.11'
  spec.summary = 'Admin for Rails'
  spec.version = RailsAdmin::Version
  spec.post_install_message = <<~MSG
    ### Upgrading to RailsAdmin 4.0 ###

    RailsAdmin now ships a prebuilt JS/CSS bundle - :propshaft and :sprockets
    apps no longer need a build step. Re-run `bin/rails g rails_admin:install`.
    config.asset_source = :webpacker / :vite are removed; :importmap falls back
    to the detected pipeline.

    Upgrade guide: https://github.com/railsadminteam/rails_admin/blob/master/docs/upgrading-to-4.md
    Changelog:     https://github.com/railsadminteam/rails_admin/blob/master/CHANGELOG.md
  MSG
end
