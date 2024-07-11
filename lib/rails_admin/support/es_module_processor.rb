

module RailsAdmin
  module Support
    class ESModuleProcessor
      def self.instance
        @instance ||= new
      end

      def self.call(input)
        instance.call(input)
      end

      def initialize; end

      def call(input)
        return unless input[:name] == 'rails_admin/application'

        input[:data].gsub(/^((?:import|export) .+)$/) { "// #{Regexp.last_match(1)}" }
      end
    end
  end
end
