require 'rubygems'

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../../Gemfile', __FILE__)
ENV['BUNDLE_GEMFILE'] = gemfile
require 'bundler'
Bundler.setup
