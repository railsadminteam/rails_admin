require 'rails_admin/adapters/active_record/abstract_object'
module RailsAdmin
  module Adapters
    module Mongoid
      class AbstractObject < RailsAdmin::Adapters::ActiveRecord::AbstractObject
        def attributes=(attributes)
          object.send :attributes=, attributes
        end

        def destroy
          object.destroy
          object
        end

        def method_missing(name, *args, &block)
          if(md = /(.+)_ids$/.match name.to_s)
            object.send(md[1].pluralize).map{|r| r.id}
          else
            super
          end
        end
      end
    end
  end
end
