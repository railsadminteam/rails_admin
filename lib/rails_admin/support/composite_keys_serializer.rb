# frozen_string_literal: true

module RailsAdmin
  module Support
    module CompositeKeysSerializer
      def self.serialize(keys)
        keys.map { |key| key&.to_s&.gsub('_', '__') }.join('_')
      end

      def self.deserialize(string)
        string.split('_').map { |key| key&.gsub('__', '_') }
      end
    end
  end
end
