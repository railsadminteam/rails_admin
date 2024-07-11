

module RailsAdmin
  module Adapters
    module ActiveRecord
      module ObjectExtension
        def assign_attributes(attributes)
          super if attributes
        end
      end
    end
  end
end
