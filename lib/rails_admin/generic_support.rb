require 'active_support/core_ext/string/inflections'
module RailsAdmin
  class AbstractModel
    module GenericSupport
      def to_param
        model.to_s.split("::").map(&:underscore).join("~")
      end
      
      def param_key
        model.to_s.split("::").map(&:underscore).join("_")
      end

      def pretty_name
        model.model_name.human
      end
    end
  end
end
