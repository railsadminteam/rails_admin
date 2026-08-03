# frozen_string_literal: true

module RailsAdmin
  module Extensions
    module UrlForExtension
      def url_for(options, ...)
        case options[:id]
        when Array
          options[:id] = RailsAdmin.config.composite_keys_serializer.serialize(options[:id])
        end
        super(options, ...)
      end
    end
  end
end
