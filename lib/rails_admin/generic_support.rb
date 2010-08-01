module MerbAdmin
  class AbstractModel
    module GenericSupport
      def to_param
        model.to_s.underscore
      end

      def pretty_name
        model.to_s.underscore.gsub('_', ' ').capitalize
      end
    end
  end
end
