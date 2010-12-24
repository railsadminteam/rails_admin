require 'active_support/core_ext/string/inflections'
module RailsAdmin
  class AbstractModel
    module GenericSupport
      def to_param
        model.to_s.underscore.pluralize
      end

      def pretty_name
        model.to_s
      end
    end
  end
end
