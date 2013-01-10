# encoding: utf-8
require File.expand_path('../lib/rails_admin/version', __FILE__)

Gem::Specification.new do |spec|
  # If you add a dependency, please maintain alphabetical order
  spec.add_dependency 'nested_form', '~> 0.2'
  spec.add_dependency 'sass-rails', '~> 3.1'
  spec.add_dependency 'bootstrap-sass', '~> 2.1'
  spec.add_dependency 'font-awesome-sass-rails', ['~> 3.0', '>= 3.0.0.1']
  spec.add_dependency 'jquery-ui-rails', '~> 3.0'
  spec.add_dependency 'builder', '~> 3.0'
  spec.add_dependency 'coffee-rails', '~> 3.1'
  spec.add_dependency 'haml', '~> 3.1'
  spec.add_dependency 'jquery-rails', '~> 2.1'
  spec.add_dependency 'kaminari', '~> 0.14'
  spec.add_dependency 'rack-pjax', '~> 0.6'
  spec.add_dependency 'rails', '~> 3.1'
  spec.add_dependency 'remotipart', '~> 1.0'
  spec.authors = ["Erik Michaels-Ober", "Bogdan Gaza", "Petteri Kaapa", "Benoit Benezech"]
  spec.description = %q{RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.}
  spec.email = ['sferik@gmail.com', 'bogdan@cadmio.org', 'petteri.kaapa@gmail.com']
  spec.files = Dir['Gemfile', 'LICENSE.md', 'README.md', 'Rakefile', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*']
  spec.licenses = ['MIT']
  spec.homepage = 'https://github.com/sferik/rails_admin'
  spec.name = 'rails_admin'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  spec.summary = %q{Admin for Rails}
  spec.test_files = Dir['spec/**/*']
  spec.version = RailsAdmin::Version
end
