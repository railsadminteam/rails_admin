require 'haml'
require 'haml/template'
if Haml::Options.buffer_option_keys.include?(:ugly)
  Haml::Template.options[:ugly] = true
end
