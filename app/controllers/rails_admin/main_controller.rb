module RailsAdmin
  class MainController < ApplicationController
    before_filter :get_model, :except => [:index, :history, :get_history]
    before_filter :get_object, :only => [:edit, :update, :delete, :destroy]
    before_filter :get_attributes, :only => [:create, :update]
    before_filter :check_for_cancel, :only => [:create, :update, :destroy]

    def index
      @page_name = t("admin.dashboard.pagename")
      @page_type = "dashboard"

      @history = History.latest
      # history listing with ref = 0 and section = 4
      @historyListing, @current_month = History.get_history_for_month(0, 4)

      @abstract_models = RailsAdmin::AbstractModel.all

      @count = {}
      @max = 0
      @abstract_models.each do |t|
        current_count = t.count
        @max = current_count > @max ? current_count : @max
        @count[t.pretty_name] = current_count
      end

      render :layout => 'rails_admin/dashboard'
    end

    def list
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
      @page_name = t("admin.actions.create").capitalize + " " + @model_config.create.label.downcase
      @page_type = @abstract_model.pretty_name.downcase
      render :layout => 'rails_admin/form'
    end

    def create
      @modified_assoc = []
      @object = @abstract_model.new
      @object.attributes = @attributes
      @object.associations = params[:associations]
      @page_name = t("admin.actions.create").capitalize + " " + @model_config.create.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      if @object.save
        redirect_to_on_success
      else
        render_error
      end
    end

    def edit
      @page_name = t("admin.actions.update").capitalize + " " + @model_config.update.label.downcase
      @page_type = @abstract_model.pretty_name.downcase
      render :layout => 'rails_admin/form'
    end

    def update
      @cached_assocations_hash = associations_hash
      @modified_assoc = []

      @page_name = t("admin.actions.update").capitalize + " " + @model_config.update.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      @old_object = @object.clone
      @object.attributes = @attributes
      @object.associations = params[:associations]
      
      if @object.save
        redirect_to_on_success
      else
        render_error :edit
      end
    end

    def delete
      @page_name = t("admin.actions.delete").capitalize + " " + @model_config.list.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      render :layout => 'rails_admin/delete'
    end

    def destroy
      @object = @object.destroy
      flash[:notice] = t("admin.delete.flash_confirmation", :name => @model_config.list.label)

      check_history

      redirect_to rails_admin_list_path(:model_name => @abstract_model.to_param)
    end

    def history
      ref = params[:ref].to_i

      if ref.nil? or ref > 0
        not_found
      else
        current_diff = -5 * ref
        start_month = (5 + current_diff).month.ago.month
        start_year = (5 + current_diff).month.ago.year
        stop_month = (current_diff).month.ago.month
        stop_year = (current_diff).month.ago.year

        render :json => History.get_history_for_dates(start_month, stop_month, start_year, stop_year)
      end
    end

    def get_history
      if params[:ref].nil? or params[:section].nil?
        not_found
      else
        @history, @current_month = History.get_history_for_month(params[:ref], params[:section])
        render :template => 'rails_admin/main/history'
      end
    end

    def show_history
      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.history.page_name", :name => @model_config.list.label)
      @general = true

      options = {}
      options[:order] = "created_at DESC"
      options[:conditions] = []
      options[:conditions] << conditions = "#{History.connection.quote_column_name(:table)} = ?"
      options[:conditions] << @abstract_model.pretty_name

      if params[:id]
        get_object
        @page_name = t("admin.history.page_name", :name => @model_config.bind(:object, @object).list.object_label)
        options[:conditions][0] += " and #{History.connection.quote_column_name(:item)} = ?"
        options[:conditions] << params[:id]
        @general = false
      end

      if params[:query]
        options[:conditions][0] += " and (#{History.connection.quote_column_name(:message)} LIKE ? or #{History.connection.quote_column_name(:username)} LIKE ?)"
        options[:conditions] << "%#{params["query"]}%"
        options[:conditions] << "%#{params["query"]}%"
      end

      if params["sort"]
        options.delete(:order)
        if params["sort_reverse"] == "true"
          options[:order] = "#{params["sort"]} desc"
        else
          options[:order] = params["sort"]
        end
      end

      @history = History.find(:all, options)

      if @general and not params[:all]
        @current_page = (params[:page] || 1).to_i
        options.merge!(:page => @current_page, :per_page => 20)
        @page_count, @history = History.paginated(options)
      end

      render :layout => request.xhr? ? false : 'rails_admin/list'
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

    def get_model
      model_name = to_model_name(params[:model_name])
      @abstract_model = RailsAdmin::AbstractModel.new(model_name)
      @model_config = RailsAdmin.config(@abstract_model)
      not_found if @model_config.excluded?
      @properties = @abstract_model.properties
    end

    def get_object
      @object = @abstract_model.get(params[:id])
      @model_config.bind(:object, @object)
      not_found unless @object
    end

    def get_sort_hash
      sort = params[:sort]
      sort ? {:sort => sort} : {}
    end

    def get_sort_reverse_hash
      sort_reverse = params[:sort_reverse]
      sort_reverse ? {:sort_reverse => sort_reverse == "true"} : {}
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
        if @abstract_model.model.serialized_attributes.keys.include?(key)
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

      check_history

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

    # TODO: Move this logic to the History class?
    def check_history
      action = params[:action]
      message = []

      case action
      when "create"
        message << "#{action.capitalize}d #{@model_config.bind(:object, @object).list.object_label}"
      when "update"
        # determine which fields changed ???
        changed_property_list = []
        @properties = @abstract_model.properties.reject{|property| RailsAdmin::History::IGNORED_ATTRS.include?(property[:name])}

        @properties.each do |property|
          property_name = property[:name].to_param
          if @old_object.send(property_name) != @object.send(property_name)
            changed_property_list << property_name
          end
        end

        @abstract_model.associations.each do |t|
          assoc = changed_property_list.index(t[:child_key].to_param)
          if assoc
            changed_property_list[assoc] = "associated #{t[:pretty_name]}"
          end
        end

        # Determine if any associations were added or removed
        associations_hash.each do |key, current|
          removed_ids = (@cached_assocations_hash[key] - current).map{|m| '#' + m.to_s}
          added_ids = (current - @cached_assocations_hash[key]).map{|m| '#' + m.to_s}
          if removed_ids.any?
            message << "Removed #{key.to_s.capitalize} #{removed_ids.join(', ')} associations"
          end
          if added_ids.any?
            message << "Added #{key.to_s.capitalize} #{added_ids.join(', ')} associations"
          end
        end

        @modified_assoc.uniq.each do |t|
          changed_property_list << "associated #{t}"
        end

        if not changed_property_list.empty?
          message << "Changed #{changed_property_list.join(", ")}"
        end
      when "destroy"
        message << "Destroyed #{@model_config.bind(:object, @object).list.object_label}"
      end

      if not message.empty?
        date = Time.now
        History.create(
          :message => message.join(', '),
          :item => @object.id,
          :table => @abstract_model.pretty_name,
          :username => _current_user ? _current_user.email : "",
          :month => date.month,
          :year => date.year
        )
      end
    end

    def render_error whereto = :new
      action = params[:action]
      flash.now[:error] = t("admin.flash.error", :name => @model_config.update.label, :action => t("admin.actions.#{action}d"))
      render whereto, :layout => 'rails_admin/form'
    end

    def to_model_name(param)
      param.split("::").map{|x| x.singularize.camelize}.join("::")
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

      # external filter
      options.merge!(other)

      associations = @model_config.list.visible_fields.select {|f| f.association? }.map {|f| f.association[:name] }
      options.merge!(:include => associations) unless associations.empty?

      if params[:all]
        options.merge!(:limit => per_page * 2)
        @objects = @abstract_model.all(options).reverse
      else
        @current_page = (params[:page] || 1).to_i
        options.merge!(:page => @current_page, :per_page => per_page)
        @page_count, @objects = @abstract_model.paginated(options)
        options.delete(:page)
        options.delete(:per_page)
        options.delete(:offset)
        options.delete(:limit)
      end

      @record_count = @abstract_model.count(options)

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
