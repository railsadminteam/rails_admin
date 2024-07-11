

CI_ORM = (ENV['CI_ORM'] || :active_record).to_sym unless defined?(CI_ORM)
CI_ASSET = (ENV['CI_ASSET'] || :sprockets).to_sym unless defined?(CI_ASSET)
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
