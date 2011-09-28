require "haml"
Haml::Template.options[:ugly] = true
Haml::Template.options[:format] = :xhtml # force closing self-closing tags for now (fix issues with xml parsing through AJAX)
