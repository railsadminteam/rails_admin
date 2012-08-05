module RailsAdmin
  class Version
    MAJOR = 0 unless defined? MAJOR
    MINOR = 0 unless defined? MINOR
    PATCH = 5 unless defined? PATCH
    PRE = nil unless defined? PRE

    class << self

      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end
