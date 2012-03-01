module RailsAdmin
  module Extensions
    module History
      class AuditingAdapter
        def initialize(controller, user_class = User)
          @controller = controller
          @user_class = user_class
          require 'rails_admin/extensions/history/history'
        end

        def latest
          ::RailsAdmin::History.latest
        end

        def delete_object(message, object, model, user)
          ::RailsAdmin::History.create_history_item(message, object, model, user)
        end

        def update_object(model, object, associations_before, associations_after, modified_associations, old_object, user)
          ::RailsAdmin::History.create_update_history(model, object, associations_before, associations_after, modified_associations, old_object, user)
        end

        def create_object(message, object, abstract_model, user)
          ::RailsAdmin::History.create_history_item(message, object, abstract_model, user)
        end

        def listing_for_model(model, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          ::RailsAdmin::History.history_for_model(model, query, sort, sort_reverse, all, page, per_page)
        end

        def listing_for_object(model, object, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          ::RailsAdmin::History.history_for_object(model, object, query, sort, sort_reverse, all, page, per_page)
        end
      end
    end
  end
end
