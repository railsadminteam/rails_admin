# frozen_string_literal: true

module RailsAdminNext
  class Version
    # The release workflow stamps the tag's version over these constants before
    # building (bin/stamp-version), so they are never bumped by hand.
    MAJOR = 1
    MINOR = 0
    PATCH = 0
    PRE = nil

    class << self
      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join(".")
      end
    end
  end
end
