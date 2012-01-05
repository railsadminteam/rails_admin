module RailsAdmin
  module Extensions
    module PaperTrail
      class VersionProxy
        def initialize(version, user_class)
          @version = version
          @user_class = user_class
        end
        
        def message
          "#{@version.event} #{@version.item_type} id #{@version.item_id}"
        end
        
        def created_at
          @version.created_at
        end
        
        def table
          @version.item_type
        end
        
        def username
          @user_class.find_by_id(@version.whodunnit).try(:email) || @version.whodunnit
        end
        
        def item
          @version.item_id
        end
      end
      
      class AuditingAdapter
        def initialize(controller, user_class)
          raise "PaperTrail not found" unless defined?(PaperTrail)
          @controller = controller
          @user_class = user_class
        end
        
        def latest
          Version.limit(100).map{|version| VersionProxy.new(version, @user_class)}
        end
        
        def delete_object(message, object, model, user)
          # do nothing
        end
        
        def update_object(model, object, associations_before, associations_after, modified_associations, old_object, user)
          # do nothing
        end
        
        def create_object(message, object, abstract_model, user)
          # do nothing
        end
        
        def listing_for_model(model, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          versions = Version.where :item_type => model.pretty_name
          versions = versions.order(sort_reverse == "true" ? "#{sort} DESC" : sort) if sort
          versions = all ? versions : versions.page(page.presence || "1").per(per_page)
          versions.map{|version| VersionProxy.new(version, @user_class)}
        end

        def listing_for_object(model, object, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          versions = Version.where :item_type => model.pretty_name, :item_id => object.id
          versions = versions.order(sort_reverse == "true" ? "#{sort} DESC" : sort) if sort
          versions = all ? versions : versions.page(page.presence || "1").per(per_page)
          versions.map{|version| VersionProxy.new(version, @user_class)}
        end
      end
    end
  end
end