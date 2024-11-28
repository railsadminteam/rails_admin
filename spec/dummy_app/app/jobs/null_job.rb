# frozen_string_literal: true

class NullJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do nothing
  end
end
