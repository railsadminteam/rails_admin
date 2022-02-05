# coding: utf-8

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_admin/version'

Gem::Specification.new do |spec|
  # If you add a dependency, please maintain alphabetical order
  spec.add_dependency 'activemodel-serializers-xml', '>= 1.0'
  spec.add_dependency 'kaminari', '>= 0.14', '< 2.0'
  spec.add_dependency 'nested_form', '~> 0.3'
  spec.add_dependency 'rails', ['>= 6.0', '< 8']
  spec.add_development_dependency 'bundler', '>= 1.0'
  spec.authors = ['Erik Michaels-Ober', 'Bogdan Gaza', 'Petteri Kaapa', 'Benoit Benezech', 'Mitsuhiro Shibuya']
  spec.description = 'RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.'
  spec.email = ['sferik@gmail.com', 'bogdan@cadmio.org', 'petteri.kaapa@gmail.com']
  spec.files = Dir['Gemfile', 'LICENSE.md', 'README.md', 'Rakefile', 'package.json', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*', 'src/**/*', 'vendor/**/*']
  spec.licenses = %w[MIT]
  spec.homepage = 'https://github.com/railsadminteam/rails_admin'
  spec.name = 'rails_admin'
  spec.require_paths = %w[lib]
  spec.required_ruby_version     = '>= 2.6.0'
  spec.required_rubygems_version = '>= 1.8.11'
  spec.summary = 'Admin for Rails'
  spec.version = RailsAdmin::Version
end
