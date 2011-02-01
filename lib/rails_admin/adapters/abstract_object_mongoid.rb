require 'rails_admin/abstract_object'
module RailsAdmin
  module Adapters
    class AbstractObjectMongoid < RailsAdmin::AbstractObject
     def attributes=(attributes)
       object.send :attributes=, attributes
     end
    end
  end
end
 