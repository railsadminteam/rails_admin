# frozen_string_literal: true

class ConsoleLogger
  def self.puts(message)
    # Ferrum passes the CDP arg's "value", which is nil for non-primitive console
    # arguments (objects, undefined). Nothing to log, and raising here would kill
    # Ferrum's subscriber thread and break every later example.
    return if message.nil?

    warn(message) unless message.start_with?('    ◀', "\n\n▶")
  end
end
