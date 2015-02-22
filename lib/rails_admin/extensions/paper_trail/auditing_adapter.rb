module RailsAdmin
  module Extensions
    module PaperTrail
      class VersionProxy
        def initialize(version, user_class = User)
          @version = version
          @user_class = user_class
        end

        def message
          @message = @version.event
          @version.respond_to?(:changeset) && @version.changeset.present? ? @message + ' [' + @version.changeset.to_a.collect { |c| c[0] + ' = ' + c[1][1].to_s }.join(', ') + ']' : @message
        end

        def created_at
          @version.created_at
        end

        def table
          @version.item_type
        end

        def username
          @user_class.find(@version.whodunnit).try(:email) rescue nil || @version.whodunnit
        end

        def item
          @version.item_id
        end
      end

      class AuditingAdapter
        COLUMN_MAPPING = {
          table: :item_type,
          username: :whodunnit,
          item: :item_id,
          created_at: :created_at,
          message: :event,
        }

        def initialize(controller, user_class = 'User', version_class = '::Version')
          fail('PaperTrail not found') unless defined?(PaperTrail)
          @controller = controller
          begin
            @user_class = user_class.to_s.constantize
          rescue NameError
            raise "Please set up Papertrail's user model explicitly. Ex: config.audit_with :paper_trail, 'User'"
          end

          begin
            @version_class = version_class.to_s.constantize
          rescue NameError
            raise "Please set up Papertrail's version model explicitly. Ex: config.audit_with :paper_trail, 'User', 'PaperTrail::Version'"
          end
        end

        def latest
          @version_class.order('id DESC').limit(100).collect { |version| VersionProxy.new(version, @user_class) }
        end

        def delete_object(_object, _model, _user)
          # do nothing
        end

        def update_object(_object, _model, _user, _changes)
          # do nothing
        end

        def create_object(_object, _abstract_model, _user)
          # do nothing
        end

        def listing_for_model(model, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          listing_for_model_or_object(model, nil, query, sort, sort_reverse, all, page, per_page)
        end

        def listing_for_object(model, object, query, sort, sort_reverse, all, page, per_page = (RailsAdmin::Config.default_items_per_page || 20))
          listing_for_model_or_object(model, object, query, sort, sort_reverse, all, page, per_page)
        end

      protected

        def listing_for_model_or_object(model, object, query, sort, sort_reverse, all, page, per_page)
          if sort.present?
            sort = COLUMN_MAPPING[sort.to_sym]
          else
            sort = :created_at
            sort_reverse = 'true'
          end

          model_name = model.model.name

          current_page = page.presence || '1'

          versions = version_class_for(model_name).where item_type: model_name
          versions = versions.where item_id: object.id if object
          versions = versions.where('event LIKE ?', "%#{query}%") if query.present?
          versions = versions.order(sort_reverse == 'true' ? "#{sort} DESC" : sort)
          versions = all ? versions : versions.send(Kaminari.config.page_method_name, current_page).per(per_page)
          paginated_proxies = Kaminari.paginate_array([], total_count: versions.total_count)
          paginated_proxies = paginated_proxies.page(current_page).per(per_page)
          versions.each do |version|
            paginated_proxies << VersionProxy.new(version, @user_class)
          end
          paginated_proxies
        end

        def version_class_for(model_name)
          klass = model_name.constantize.
                  try(:version_class_name).
                  try(:constantize)

          klass || @version_class
        end
      end
    end
  end
end
