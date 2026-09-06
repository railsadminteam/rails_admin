# frozen_string_literal: true

class ConsoleLogger
  # Lines Ferrum wraps around the actual console message that examples never want
  # forwarded to #warn (doing so also trips `receive(:warn).with(...)` stubs):
  # its own CDP protocol frames ("    ◀" / "▶"), and - since ferrum 0.18 - one
  # "    at fn (url:line:col)" line per stack frame of the console call.
  NOISE = /\A(?:    (?:◀|at )|\n\n▶)/.freeze

  def self.puts(message)
    warn(message) unless message.to_s.match?(NOISE)
  end
end
