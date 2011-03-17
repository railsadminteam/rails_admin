module RailsAdmin
  class MainController < RailsAdmin::ApplicationController
    before_filter :get_model, :except => [:index]
    before_filter :get_object, :only => [:edit, :update, :delete, :destroy]
    before_filter :get_bulk_objects, :only => [:bulk_delete, :bulk_destroy]
    before_filter :get_attributes, :only => [:create, :update]
    before_filter :check_for_cancel, :only => [:create, :update, :destroy, :bulk_destroy]

    def index
      @authorization_adapter.authorize(:index) if @authorization_adapter
      @page_name = t("admin.dashboard.pagename")
      @page_type = "dashboard"

      @history = AbstractHistory.history_latest_summaries
      # history listing with ref = 0 and section = 4
      @historyListing, @current_month = AbstractHistory.history_for_month(0, 4)

      @abstract_models = RailsAdmin::AbstractModel.all

      @most_recent_changes = {}
      @count = {}
      @max = 0
      @abstract_models.each do |t|
        current_count = t.count
        @max = current_count > @max ? current_count : @max
        @count[t.pretty_name] = current_count
        @most_recent_changes[t.pretty_name] = AbstractHistory.most_recent_history(t.pretty_name).last.try(:updated_at)
      end

      render :layout => 'rails_admin/dashboard'
    end

    def list
      @authorization_adapter.authorize(:list, @abstract_model) if @authorization_adapter
      list_entries
      @xhr = request.xhr?
      visible = lambda { @model_config.list.visible_fields.map {|f| f.name } }
      respond_to do |format|
        format.html { render :layout => @xhr ? false : 'rails_admin/list' }
        format.json { render :json => @objects.to_json(:only => visible.call) }
        format.xml { render :xml => @objects.to_json(:only => visible.call) }
      end
    end

    def new
      @object = @abstract_model.new
      if @authorization_adapter
        @authorization_adapter.attributes_for(:new, @abstract_model).each do |name, value|
          @object.send("#{name}=", value)
        end
        @authorization_adapter.authorize(:new, @abstract_model, @object)
      end
      @page_name = t("admin.actions.create").capitalize + " " + @model_config.create.label.downcase
      @page_type = @abstract_model.pretty_name.downcase
      render :layout => 'rails_admin/form'
    end

    def create
      @modified_assoc = []
      @object = @abstract_model.new
      if @authorization_adapter
        @authorization_adapter.attributes_for(:create, @abstract_model).each do |name, value|
          @object.send("#{name}=", value)
        end
        @authorization_adapter.authorize(:create, @abstract_model, @object)
      end
      @object.attributes = @attributes
      @object.associations = params[:associations]
      @page_name = t("admin.actions.create").capitalize + " " + @model_config.create.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      if @object.save
        AbstractHistory.create_history_item("Created #{@model_config.list.with(:object => @object).object_label}", @object, @abstract_model, _current_user)
        redirect_to_on_success
      else
        render_error
      end
    end

    def edit
      @authorization_adapter.authorize(:edit, @abstract_model, @object) if @authorization_adapter

      @page_name = t("admin.actions.update").capitalize + " " + @model_config.update.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      render :layout => 'rails_admin/form'
    end

    def update
      @authorization_adapter.authorize(:update, @abstract_model, @object) if @authorization_adapter

      @cached_assocations_hash = associations_hash
      @modified_assoc = []

      @page_name = t("admin.actions.update").capitalize + " " + @model_config.update.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      @old_object = @object.clone

      @object.attributes = @attributes
      @object.associations = params[:associations]

      if @object.save
        AbstractHistory.create_update_history @abstract_model, @object, @cached_assocations_hash, associations_hash, @modified_assoc, @old_object, _current_user
        redirect_to_on_success
      else
        render_error :edit
      end
    end

    def delete
      @authorization_adapter.authorize(:delete, @abstract_model, @object) if @authorization_adapter

      @page_name = t("admin.actions.delete").capitalize + " " + @model_config.list.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      render :layout => 'rails_admin/delete'
    end

    def destroy
      @authorization_adapter.authorize(:destroy, @abstract_model, @object) if @authorization_adapter

      @object = @object.destroy
      flash[:notice] = t("admin.delete.flash_confirmation", :name => @model_config.list.label)

      AbstractHistory.create_history_item("Destroyed #{@model_config.list.with(:object => @object).object_label}", @object, @abstract_model, _current_user)

      redirect_to rails_admin_list_path(:model_name => @abstract_model.to_param)
    end

    def bulk_delete
      @authorization_adapter.authorize(:bulk_delete, @abstract_model) if @authorization_adapter

      @page_name = t("admin.actions.delete").capitalize + " " + @model_config.list.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      render :layout => 'rails_admin/delete'
    end

    def bulk_destroy
      @authorization_adapter.authorize(:bulk_destroy, @abstract_model) if @authorization_adapter

      scope = @authorization_adapter && @authorization_adapter.query(params[:action].to_sym, @abstract_model)
      @destroyed_objects = @abstract_model.destroy(params[:bulk_ids], scope)

      @destroyed_objects.each do |object|
        message = "Destroyed #{@model_config.list.with(:object => object).object_label}"
        AbstractHistory.create_history_item(message, object, @abstract_model, _current_user)
      end

      redirect_to rails_admin_list_path(:model_name => @abstract_model.to_param)
    end

    def handle_error(e)
      if RailsAdmin::AuthenticationNotConfigured === e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")

        @error = e
        render 'authentication_not_setup', :status => 401
      else
        super
      end
    end

    private

    def get_bulk_objects
      scope = @authorization_adapter && @authorization_adapter.query(params[:action].to_sym, @abstract_model)
      @bulk_ids = params[:bulk_ids]
      @bulk_objects = @abstract_model.get_bulk(@bulk_ids, scope)

      not_found unless @bulk_objects
    end

    def get_sort_hash
      sort = params[:sort] || RailsAdmin.config(@abstract_model).list.sort_by
      {:sort => sort}
    end

    def get_sort_reverse_hash
      sort_reverse = if params[:sort]
          params[:sort_reverse] == 'true'
      else
        not RailsAdmin.config(@abstract_model).list.sort_reverse?
      end
      {:sort_reverse => sort_reverse}
    end

    def get_query_hash(options)
      query = params[:query]
      return {} unless query
      statements = []
      values = []
      conditions = options[:conditions] || [""]
      table_name = @abstract_model.model.table_name

      @properties.select{|property| property[:type] == :string}.each do |property|
        statements << "(#{table_name}.#{property[:name]} LIKE ?)"
        values << "%#{query}%"
      end

      conditions[0] += " AND " unless conditions == [""]
      conditions[0] += statements.join(" OR ")
      conditions += values
      conditions != [""] ? {:conditions => conditions} : {}
    end

    def get_filter_hash(options)
      filter = params[:filter]
      return {} unless filter
      statements = []
      values = []
      conditions = options[:conditions] || [""]
      table_name = @abstract_model.model.table_name

      filter.each_pair do |key, value|
        @properties.select{|property| property[:type] == :boolean && property[:name] == key.to_sym}.each do |property|
          statements << "(#{table_name}.#{key} = ?)"
          values << (value == "true")
        end
      end

      conditions[0] += " AND " unless conditions == [""]
      conditions[0] += statements.join(" AND ")
      conditions += values
      conditions != [""] ? {:conditions => conditions} : {}
    end

    def get_attributes
      @attributes = params[@abstract_model.to_param] || {}
      @attributes.each do |key, value|
        # Deserialize the attribute if attribute is serialized
        if @abstract_model.model.serialized_attributes.keys.include?(key) and value.is_a? String
          @attributes[key] = YAML::load(value)
        end
        # Delete fields that are blank
        @attributes[key] = nil if value.blank?
      end
    end

    def redirect_to_on_success
      param = @abstract_model.to_param
      pretty_name = @model_config.update.label
      action = params[:action]

      if params[:_add_another]
        flash[:notice] = t("admin.flash.successful", :name => pretty_name, :action => t("admin.actions.#{action}d"))
        redirect_to rails_admin_new_path(:model_name => param)
      elsif params[:_add_edit]
        flash[:notice] = t("admin.flash.successful", :name => pretty_name, :action => t("admin.actions.#{action}d"))
        redirect_to rails_admin_edit_path(:model_name => param, :id => @object.id)
      else
        flash[:notice] = t("admin.flash.successful", :name => pretty_name, :action => t("admin.actions.#{action}d"))
        redirect_to rails_admin_list_path(:model_name => param)
      end
    end

    def render_error whereto = :new
      action = params[:action]
      flash.now[:error] = t("admin.flash.error", :name => @model_config.update.label, :action => t("admin.actions.#{action}d"))
      render whereto, :layout => 'rails_admin/form'
    end

    def check_for_cancel
      if params[:_continue]
        flash[:notice] = t("admin.flash.noaction")
        redirect_to rails_admin_list_path(:model_name => @abstract_model.to_param)
      end
    end

    def list_entries(other = {})
      options = {}
      options.merge!(get_sort_hash)
      options.merge!(get_sort_reverse_hash)
      options.merge!(get_query_hash(options))
      options.merge!(get_filter_hash(options))
      per_page = @model_config.list.items_per_page

      scope = @authorization_adapter && @authorization_adapter.query(:list, @abstract_model)

      # external filter
      options.merge!(other)

      associations = @model_config.list.visible_fields.select {|f| f.association? }.map {|f| f.association[:name] }
      options.merge!(:include => associations) unless associations.empty?

      if params[:all]
        options.merge!(:limit => per_page * 2)
        @objects = @abstract_model.all(options, scope).reverse
      else
        @current_page = (params[:page] || 1).to_i
        options.merge!(:page => @current_page, :per_page => per_page)
        @page_count, @objects = @abstract_model.paginated(options, scope)
        options.delete(:page)
        options.delete(:per_page)
        options.delete(:offset)
        options.delete(:limit)
      end

      @record_count = @abstract_model.count(options, scope)

      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.list.select", :name => @model_config.list.label.downcase)
    end

    def associations_hash
      associations = {}
      @abstract_model.associations.each do |association|
        if [:has_many, :has_and_belongs_to_many].include?(association[:type])
          records = Array(@object.send(association[:name]))
          associations[association[:name]] = records.collect(&:id)
        end
      end
      associations
    end

  end
end
