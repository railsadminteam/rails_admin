require 'capybara/poltergeist'

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: 'open')
end

Capybara.javascript_driver = :poltergeist

module PoltergeistHelper
  # Poltergeist debug version of RSpec's it "Do something" block.
  # Usage: Rename  it block to call debugit
  # Use page page.driver.debug where wish to stop
  def debugit(*args, &block)
    it(*args, {driver: :poltergeist_debug, inspector: true}, &block)
  end
end
