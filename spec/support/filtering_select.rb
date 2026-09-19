# frozen_string_literal: true

module FilteringSelectHelper
  ITEMS = 'ul.ui-autocomplete li.ui-menu-item a'

  # Type +query+ into a filtering select and let jQuery UI start its search.
  def filter_by(query, scope: nil)
    input = [scope, 'input.ra-filtering-select-input'].compact.join(' ')
    find(input).set(query)
    page.execute_script("document.querySelector('#{input}').dispatchEvent(new KeyboardEvent('keydown'))")
  end

  # Wait for the autocomplete menu to hold exactly +items+, in order.
  #
  # Waiting for a single entry is not enough to tell the new menu from the old
  # one: jQuery UI leaves the previous query's menu in the DOM until the new
  # response arrives, so an entry that appears in both result sets matches while
  # the search is still in flight. Reading the list with #all has the same
  # problem - it returns as soon as one item is there, stale or not. Retrying
  # the whole comparison waits for the list itself instead of for a symptom.
  #
  # That also means this waits for more than the default two seconds usually
  # has to cover: the widget's own search delay, a request, and the re-render.
  # The longer window costs nothing while the menu does turn up, and applies
  # here only - every other expectation keeps the default.
  def expect_autocomplete_items(items, ordered: true, wait: 5)
    expected = ordered ? items : items.sort
    page.document.synchronize(wait) do
      texts = all(ITEMS, minimum: items.size).map(&:text)
      listed = ordered ? texts : texts.sort
      raise Capybara::ExpectationNotMet.new("autocomplete listed #{texts.inspect}") unless listed == expected

      texts
    end
  end
end

RSpec.configure do |config|
  config.include FilteringSelectHelper, type: :request
end
