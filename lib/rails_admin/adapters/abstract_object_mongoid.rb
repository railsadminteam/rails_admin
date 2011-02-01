require 'rails_admin/abstract_object'
module RailsAdmin
  module Adapters
    class AbstractObjectMongoid < RailsAdmin::AbstractObject
     def attributes=(attributes)
       object.send :attributes=, attributes
     end

     def destroy
       object.destroy
       object
     end
    end
  end
end
