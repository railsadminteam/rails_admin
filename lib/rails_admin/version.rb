module RailsAdmin
  class Version
    MAJOR = 3
    MINOR = 0
    PATCH = 0
    PRE = 'beta2'.freeze

    class << self
      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

      def js
        JSON.parse(File.read("#{__dir__}/../../package.json"))['version']
      end
    end
  end
end
