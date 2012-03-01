module RailsAdmin
  module Extensions
    module PaperTrail
      class VersionProxy
        def initialize(version, user_class = User)
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
        COLUMN_MAPPING = {
          :table => :item_type,
          :username => :whodunnit,
          :item => :item_id,
          :created_at => :created_at,
          :message => :event
        }

        def initialize(controller, user_class = User)
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
          if sort.present?
            sort = COLUMN_MAPPING[sort.to_sym]
          else
            sort = :created_at
            sort_reverse = "true"
          end
          versions = Version.where :item_type => model.model.name
          versions = versions.where("event LIKE ?", "%#{query}%") if query.present?
          versions = versions.order(sort_reverse == "true" ? "#{sort} DESC" : sort)
          versions = all ? versions : versions.page(page.presence || "1").per(per_page)
          versions.map{|version| VersionProxy.new(version, @user_class)}
        end

        def listing_for_object(model, object, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          if sort.present?
            sort = COLUMN_MAPPING[sort.to_sym]
          else
            sort = :created_at
            sort_reverse = "true"
          end
          versions = Version.where :item_type => model.model.name, :item_id => object.id
          versions = versions.where("event LIKE ?", "%#{query}%") if query.present?
          versions = versions.order(sort_reverse == "true" ? "#{sort} DESC" : sort)
          versions = all ? versions : versions.page(page.presence || "1").per(per_page)
          versions.map{|version| VersionProxy.new(version, @user_class)}
        end
      end
    end
  end
end
