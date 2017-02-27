require 'haml'

if Gem::Version.create(Haml::VERSION) < Gem::Version.create('5.0.0.beta.2')
  Haml::Template.options[:ugly] = true
end
