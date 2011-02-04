require 'active_support/core_ext/string/inflections'
module RailsAdmin
  class AbstractModel
    module GenericSupport
      def to_param
        parts = model.to_s.split("::")
        parts.map{|x| x == parts.last ? x.underscore.pluralize : x.underscore}.join("::")
      end

      def pretty_name
        model.to_s
      end
    end
  end
end
