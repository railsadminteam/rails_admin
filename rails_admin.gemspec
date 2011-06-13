# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  # If you add a dependency, please maintain alphabetical order
  gem.add_development_dependency 'devise', '~> 1.1'
  gem.add_development_dependency 'dummy_data', '~> 0.9'
  gem.add_development_dependency 'maruku', '~> 0.6'
  gem.add_development_dependency 'paperclip', '~> 2.3'
  gem.add_development_dependency 'rspec-rails', '~> 2.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'webrat', '~> 0.7'
  gem.add_development_dependency 'yard', '~> 0.7'
  gem.add_development_dependency 'ZenTest', '~> 4.5'
  
  gem.add_runtime_dependency 'builder', '~> 2.1.0'
  gem.add_runtime_dependency 'fastercsv'
  gem.add_runtime_dependency 'haml', ['>= 3.0.0', '< 3.2.0']
  gem.add_runtime_dependency 'rails', '~> 3.0.7'
  
  gem.authors = ["Erik Michaels-Ober", "Bogdan Gaza", "Petteri Kääpä"]
  gem.description = %q{RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data}
  gem.email = ['sferik@gmail.com', 'bogdan@cadmio.org', 'petteri.kaapa@gmail.com']
  gem.files = Dir['Gemfile', 'LICENSE.md', 'README.md', 'Rakefile', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*']
  gem.homepage = 'https://github.com/sferik/rails_admin'
  gem.name = 'rails_admin'
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = %q{Admin for Rails}
  gem.test_files = Dir['spec/**/*']
  # FIXME: this should reference RailsAdmin::VERSION but because of
  # http://jira.codehaus.org/browse/JRUBY-5319 we can't use "require"
  # in our gemspec
  gem.version = '0.0.1'
end
