# frozen_string_literal: true

module RailsAdmin
  module Support
    # Writes the values of a composite primary key as one string, and reads it
    # back.
    #
    # The delimiter is the one ActiveRecord joins a composite id with, so an
    # ordinary key comes out looking exactly like the record's own to_param. A
    # key value is free to contain the delimiter, though, so it is escaped to a
    # form that cannot: the escape character followed by the byte in hex.
    #
    # Doubling the delimiter, which is what this used to do, cannot be undone --
    # ["a_", "b"] and ["a", "_b"] both come out as "a___b". Values holding a
    # delimiter have therefore never round-tripped; nothing else changes shape.
    module CompositeKeysSerializer
      DELIMITER = '_'
      ESCAPE = '~' # unreserved in a URI, so it survives a path segment as it is
      UNSAFE = /[#{Regexp.escape(ESCAPE + DELIMITER)}]/.freeze
      ESCAPED = /#{Regexp.escape(ESCAPE)}([0-9A-Fa-f]{2})/.freeze

      def self.serialize(keys)
        keys.map { |key| escape(key) }.join(DELIMITER)
      end

      def self.deserialize(string)
        string.split(DELIMITER, -1).map { |key| unescape(key) }
      end

      def self.escape(key)
        key&.to_s&.gsub(UNSAFE) { |char| format('%s%02X', ESCAPE, char.ord) }
      end

      def self.unescape(key)
        key&.gsub(ESCAPED) { Regexp.last_match(1).hex.chr }
      end

      private_class_method :escape, :unescape
    end
  end
end
