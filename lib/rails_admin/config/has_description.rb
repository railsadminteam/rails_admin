module RailsAdmin
  module Config
    # Provides accessor and autoregistering of model's description.
    module HasDescription
      attr_reader :description

      def desc(description, &_block)
        @description ||= description
      end
    end
  end
end
