# encoding: utf-8
require File.expand_path('../lib/rails_admin/version', __FILE__)

Gem::Specification.new do |gem|
  # If you add a dependency, please maintain alphabetical order
  gem.add_dependency 'bbenezech-nested_form', '~> 0.0'
  gem.add_dependency 'bootstrap-sass', ['~> 1.4', '>= 1.4.1']
  gem.add_dependency 'builder', '~> 3.0'
  gem.add_dependency 'coffee-rails', '~> 3.1'
  gem.add_dependency 'haml', '~> 3.1'
  gem.add_dependency 'jquery-rails', '>= 1.0'
  gem.add_dependency 'kaminari', '~> 0.12'
  gem.add_dependency 'rack-pjax', '~> 0.5'
  gem.add_dependency 'rails', '~>3.1'
  gem.add_dependency 'remotipart', '~> 1.0'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'carrierwave'
  gem.add_development_dependency 'devise'
  gem.add_development_dependency 'dragonfly'
  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'generator_spec'
  gem.add_development_dependency 'launchy'
  gem.add_development_dependency 'mini_magick'
  gem.add_development_dependency 'paperclip'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'simplecov'
  gem.authors = ["Erik Michaels-Ober", "Bogdan Gaza", "Petteri Kaapa", "Benoit Benezech"]
  gem.description = %q{RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.}
  gem.email = ['sferik@gmail.com', 'bogdan@cadmio.org', 'petteri.kaapa@gmail.com']
  gem.files = Dir['Gemfile', 'LICENSE.md', 'README.md', 'Rakefile', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*']
  gem.homepage = 'https://github.com/sferik/rails_admin'
  gem.name = 'rails_admin'
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = %q{Admin for Rails}
  gem.test_files = Dir['spec/**/*']
  gem.version = RailsAdmin::VERSION
end
