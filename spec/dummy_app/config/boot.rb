CI_ORM = (ENV['CI_ORM'] || :active_record).to_sym unless defined?(CI_ORM)
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
