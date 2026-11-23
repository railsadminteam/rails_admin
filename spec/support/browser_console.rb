# frozen_string_literal: true

module BrowserConsoleHelper
  # Forget what the page logged, for an example which drives the browser into a
  # console message on purpose, so that the after hook does not report it.
  # Older Rubies resolve to cuprite < 0.20, which has no console API.
  def clear_browser_console
    browser = page.driver.browser
    browser.console.clear if browser.respond_to?(:console)
  end
end

RSpec.configure do |config|
  config.include BrowserConsoleHelper, type: :request
end
