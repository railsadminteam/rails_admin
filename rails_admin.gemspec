# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  # If you add a development dependency, please maintain alphabetical order
  s.add_development_dependency('devise', '~> 1.1')
  s.add_development_dependency('dummy_data', '~> 0.9')
  s.add_development_dependency('maruku', '~> 0.6')
  s.add_development_dependency('paperclip', '~> 2.3')
  s.add_development_dependency('rspec-rails', '~> 2.5')
  s.add_development_dependency('rr', '~> 1.0.2')
  s.add_development_dependency('simplecov', '~> 0.4')
  s.add_development_dependency('webrat', '~> 0.7')
  s.add_development_dependency('yard', '~> 0.6')
  s.add_development_dependency('ZenTest', '~> 4.5')
  # If you add a runtime dependency, please maintain alphabetical order
  s.add_runtime_dependency('builder', '~> 2.1.0')
  s.add_runtime_dependency('rails', '~> 3.0.6')
  s.authors = ["Erik Michaels-Ober", "Bogdan Gaza"]
  s.description = %q{RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data}
  s.email = ['sferik@gmail.com']
  s.extra_rdoc_files = ['LICENSE.md', 'README.md']
  s.files = Dir['Gemfile', 'LICENSE.md', 'README.md', 'Rakefile', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*']
  s.homepage = 'http://rubygems.org/gems/rails_admin'
  s.name = 'rails_admin'
  s.platform = Gem::Platform::RUBY
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = 'rails_admin'
  s.summary = %q{Admin for Rails}
  s.test_files = Dir['spec/**/*']
  # FIXME: this should reference RailsAdmin::VERSION but because of
  # http://jira.codehaus.org/browse/JRUBY-5319 we can't use "require"
  # in our gemspec
  s.version = '0.0.1'
end
