unless defined?(CI_ORM)
  CI_ORM = (ENV["CI_ORM"] || :active_record).to_sym
end
require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE']) && !ENV['TRAVIS']
