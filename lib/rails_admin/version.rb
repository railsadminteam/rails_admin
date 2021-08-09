module RailsAdmin
  class Version
    MAJOR = 3
    MINOR = 0
    PATCH = 0
    PRE = 'alpha'.freeze

    class << self
      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end
    end
  end
end
