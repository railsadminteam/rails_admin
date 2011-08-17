# encoding: utf-8
require File.expand_path('../lib/rails_admin/version', __FILE__)

Gem::Specification.new do |gem|
  # If you add a dependency, please maintain alphabetical order
  gem.add_dependency 'builder', '~> 3.0.0'
  gem.add_dependency 'haml', ['>= 3.1.0', '< 3.3.0']
  gem.add_dependency 'rails', '~> 3.1.0.rc6'
  gem.add_development_dependency 'capybara', '~> 1.0'
  gem.add_development_dependency 'launchy', '~> 2.0'
  gem.add_development_dependency 'devise', '~> 1.4'
  gem.add_development_dependency 'factory_girl', '~> 2.0'
  gem.add_development_dependency 'generator_spec', '~> 0.8'
  gem.add_development_dependency 'paperclip', '~> 2.3'
  gem.add_development_dependency 'rspec-rails', '~> 2.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.authors = ["Erik Michaels-Ober", "Bogdan Gaza", "Petteri Kääpä"]
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
