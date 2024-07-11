

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
CI_ORM = (ENV['CI_ORM'] || :active_record).to_sym
CI_TARGET_ORMS = %i[active_record mongoid].freeze
PK_COLUMN = {active_record: :id, mongoid: :_id}[CI_ORM]

if RUBY_ENGINE == 'jruby'
  # Workaround for JRuby CI failure https://github.com/jruby/jruby/issues/6547#issuecomment-774104996
  require 'i18n/backend'
  require 'i18n/backend/simple'
end

require 'simplecov'
require 'simplecov-lcov'

SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::LcovFormatter]

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/bundle/'
end

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.single_report_path = 'coverage/lcov.info'
end

require File.expand_path('dummy_app/config/environment', __dir__)

require 'rspec/rails'
require 'factory_bot'
require 'factories'
require 'policies'
require "database_cleaner/#{CI_ORM}"
require "orm/#{CI_ORM}"
require 'paper_trail/frameworks/rspec' if defined?(PaperTrail)

Dir[File.expand_path('support/**/*.rb', __dir__),
    File.expand_path('shared_examples/**/*.rb', __dir__)].sort.each { |f| require f }

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = 'example.com'

Rails.backtrace_cleaner.remove_silencers!

require 'capybara/cuprite'
Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, js_errors: true, logger: ConsoleLogger)
end
Capybara.server = :webrick

RailsAdmin.setup_all_extensions

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.disable_monkey_patching!

  config.include RSpec::Matchers
  config.include RailsAdmin::Engine.routes.url_helpers

  config.include Warden::Test::Helpers

  config.include Capybara::DSL, type: :request

  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.around :each, :js do |example|
    example.run_with_retry retry: (ENV['CI'] && RUBY_ENGINE == 'jruby' ? 3 : 2)
  end
  config.retry_callback = proc do |example|
    example.metadata[:retry] = 6 if [Ferrum::DeadBrowserError, Ferrum::NoExecutionContextError, Ferrum::TimeoutError].include?(example.exception.class)
    if example.metadata[:js]
      attempt = 0
      begin
        Capybara.reset!
      rescue Ferrum::TimeoutError, Ferrum::NoExecutionContextError
        attempt += 1
        raise if attempt >= 5

        retry
      end
    end
  end

  config.before(:all) do
    case CI_ASSET
    when :webpacker
      Webpacker.instance.compiler.compile
    when :vite
      ViteRuby.instance.commands.build
    end
  end

  config.before do |example|
    DatabaseCleaner.strategy =
      if CI_ORM == :mongoid || example.metadata[:js]
        :deletion
      else
        :transaction
      end

    DatabaseCleaner.start
    RailsAdmin::Config.reset
    RailsAdmin::Config.asset_source = CI_ASSET
  end

  config.after(:each) do
    Warden.test_reset!
    DatabaseCleaner.clean
  end

  CI_TARGET_ORMS.each do |orm|
    if orm == CI_ORM
      config.filter_run_excluding "skip_#{orm}": true
    else
      config.filter_run_excluding orm => true
    end
  end

  config.filter_run_excluding composite_primary_keys: true unless defined?(CompositePrimaryKeys)
end
