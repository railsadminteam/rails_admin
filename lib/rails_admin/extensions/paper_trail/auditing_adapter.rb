module RailsAdmin
  module Extensions
    module PaperTrail
      class AuditingAdapter
        def initialize(controller)
          @controller = controller
        end
        
        def latest
          [] # todo
        end
        
        def delete_object(message, object, model, user)
          # do nothing (Papertrail is hooked in ActiveRecord)
        end
        
        def update_object(model, object, associations_before, associations_after, modified_associations, old_object, user)
          # do nothing (Papertrail is hooked in ActiveRecord)
        end
        
        def create_object(message, object, abstract_model, user)
          # do nothing (Papertrail is hooked in ActiveRecord)
        end
        
        def listing_for_model(model, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          [] # todo
        end

        def listing_for_object(model, object, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          [] # todo
        end
      end
    end
  end
end