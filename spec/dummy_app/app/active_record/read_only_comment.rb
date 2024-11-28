# frozen_string_literal: true

class ReadOnlyComment < Comment
  def readonly?
    true
  end
end
