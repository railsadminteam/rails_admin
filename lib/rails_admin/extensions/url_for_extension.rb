# frozen_string_literal: true

module RailsAdmin
  module Extensions
    # Writes a composite id into a URL for callers that hand url_for the id
    # straight from a record.
    #
    # Everywhere RailsAdmin knows which model an id belongs to it asks that
    # model's repository instead, which is the only place that decides how an id
    # is written down. This is the net underneath: by the time url_for sees the
    # id there is no model left to ask, so it can only fall back to the globally
    # configured serializer.
    module UrlForExtension
      def url_for(options, *args)
        case options[:id]
        when Array
          options[:id] = RailsAdmin.config.composite_keys_serializer.serialize(options[:id])
        end
        super options, *args
      end
    end
  end
end
