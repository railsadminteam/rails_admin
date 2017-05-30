module RailsAdmin
  class Version
    MAJOR = 1
    MINOR = 1
    PATCH = 2
    PRE = nil

    class << self
      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end
    end
  end
end
