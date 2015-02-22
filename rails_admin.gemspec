# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_admin/version'

Gem::Specification.new do |spec|
  # If you add a dependency, please maintain alphabetical order
  spec.add_dependency 'builder', '~> 3.1'
  spec.add_dependency 'coffee-rails', '~> 4.0'
  spec.add_dependency 'font-awesome-rails', ['>= 3.0', '< 5']
  spec.add_dependency 'haml', '~> 4.0'
  spec.add_dependency 'jquery-rails', ['>= 3.0', '< 5']
  spec.add_dependency 'jquery-ui-rails', '~> 5.0'
  spec.add_dependency 'kaminari', '~> 0.14'
  spec.add_dependency 'nested_form', '~> 0.3'
  spec.add_dependency 'rack-pjax', '~> 0.7'
  spec.add_dependency 'rails', '~> 4.0'
  spec.add_dependency 'remotipart', '~> 1.0'
  spec.add_dependency 'safe_yaml', '~> 1.0'
  spec.add_dependency 'sass-rails', ['>= 4.0', '< 6']
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.authors = ['Erik Michaels-Ober', 'Bogdan Gaza', 'Petteri Kaapa', 'Benoit Benezech']
  spec.description = 'RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.'
  spec.email = ['sferik@gmail.com', 'bogdan@cadmio.org', 'petteri.kaapa@gmail.com']
  spec.files = Dir['Gemfile', 'LICENSE.md', 'README.md', 'Rakefile', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*']
  spec.licenses = %w(MIT)
  spec.homepage = 'https://github.com/sferik/rails_admin'
  spec.name = 'rails_admin'
  spec.require_paths = %w(lib)
  spec.required_ruby_version     = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.8.11'
  spec.summary = 'Admin for Rails'
  spec.version = RailsAdmin::Version
end
