require 'rails_admin/abstract_model'

class RailsAdminController < ApplicationController
  before_filter :authenticate_user!

  before_filter :get_model, :except => [:index,:history, :get_history]
  before_filter :get_object, :only => [:edit, :update, :delete, :destroy]
  before_filter :get_attributes, :only => [:create, :update]
  before_filter :set_plugin_name
  before_filter :check_for_cancel

  def index
    @page_name = "Site administration"
    @page_type = "dashboard"

    @history = History.latest
    # history listing with ref = 0 and section = 4
    @historyListing, @current_month = History.get_history_for_month(0,4)

    @abstract_models = RailsAdmin::AbstractModel.all
    
    @count = {}
    @max = 0
    @abstract_models.each do |t|
      current_count =t.count
      @max = current_count > @max ? current_count : @max

      @count[t.pretty_name] = current_count
    end

    render(:layout => 'dashboard')
  end

  def list
    list_entries
    render :layout => 'list'
  end

  def new
    @object = @abstract_model.new
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = RailsAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase

    render :layout => 'form'
  end

  def create
    @object = @abstract_model.new(@attributes)
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = RailsAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase

    if @object.save && update_all_associations
      @lastId = @object.id
      redirect_to_on_success
    else
      render_error
    end
  end

  def edit
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = RailsAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase

    render(:layout => 'form')
  end

  def update
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = RailsAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase

    if @object.update_attributes(@attributes) && update_all_associations
      @lastId = @object.id
      redirect_to_on_success
    else
      render_error
    end
  end

  def delete
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = RailsAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase

    render(:layout => 'delete')
  end

  def destroy
    @object.destroy
    flash[:notice] = "#{@abstract_model.pretty_name} was successfully destroyed"
    redirect_to rails_admin_list_path(:model_name => @abstract_model.to_param)
  end

  def get_pages
    list_entries
    @xhr = true;
    render :template => "rails_admin/list.html"
  end

  def history
    ref = params[:ref].to_i

    if ref.nil? or ref > 0
      show404
    else
      current_diff = -5 * ref
      start_month = (5+current_diff).month.ago.month
      start_year = (5+current_diff).month.ago.year
      stop_month = (current_diff).month.ago.month
      stop_year = (current_diff).month.ago.year

      render :json => History.get_history_for_dates(start_month,stop_month,start_year,stop_year)
    end
  end

  def get_history
    if params[:ref].nil? or params[:section].nil?
      show404
    else
      @history, @current_month = History.get_history_for_month(params[:ref],params[:section])
      render :template => "rails_admin/history"
    end
  end

  private

  def get_model
    model_name = to_model_name(params[:model_name])
    # FIXME: What method AbstractModel calls? => initialize.
    @abstract_model = RailsAdmin::AbstractModel.new(model_name)
    @properties = @abstract_model.properties

  end

  def get_object
    @object = @abstract_model.get(params[:id])
    # FIXME
    render :file => Rails.root.join('public', '404.html'), :layout => false, :status => 404 unless @object
  end

  def show404
    render :file => Rails.root.join('public', '404.html'), :layout => false, :status => 404 unless @object
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

    @properties.select{|property| property[:type] == :string}.each do |property|
      statements << "(#{property[:name]} LIKE ?)"
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

    filter.each_pair do |key, value|
      @properties.select{|property| property[:type] == :boolean && property[:name] == key.to_sym}.each do |property|
        statements << "(#{key} = ?)"
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

    # Delete fields that are blank
    @attributes.each do |key, value|
      @attributes[key] = nil if value.blank?
    end
  end

  def update_all_associations
    @abstract_model.associations.each do |association|
      ids = (params[:associations] || {}).delete(association[:name])

      case association[:type]
      when :has_one
        update_association(association, ids)
      when :has_many
        update_associations(association, ids.to_a)
      end
    end
  end

  def update_association(association, id = nil)
    associated_model = RailsAdmin::AbstractModel.new(association[:child_model])
    if object = associated_model.get(id)
      object.update_attributes(association[:child_key].first => @object.id)
    end
  end

  def update_associations(association, ids = [])
    @object.send(association[:name]).clear
    ids.each do |id|
      update_association(association, id)
    end
    @object.save
  end

  def redirect_to_on_success
    param = @abstract_model.to_param
    pretty_name = @abstract_model.pretty_name
    action = params[:action]

    check_history

    if params[:_add_another] == "Save and add another"
      flash[:notice] = "#{pretty_name} was successfully #{action}d"
      redirect_to rails_admin_new_path( :model_name => param)
    elsif params[:_add_edit] == "Save and edit"
      flash[:notice] = "#{pretty_name} was successfully #{action}d"
      redirect_to rails_admin_edit_path( :model_name => param,:id =>@lastId)
    elsif
      flash[:notice] = "#{pretty_name} was successfully #{action}d"
      redirect_to rails_admin_list_path(:model_name => param)
    end
  end

  def check_history
    action = params[:action]
    action_type = -1

    case action
    when "create"
      action_type = 1
    when "update"
      action_type=2
    when "distroy"
      action_type=3
    end

    if action_type != -1
      date = Time.now
      History.create(:action => action_type,:month =>date.month, :year => date.year, :user_id => current_user.id)
    end
  end

  def render_error
    action = params[:action]
    flash.now[:error] = "#{@abstract_model.pretty_name} failed to be #{action}d"
    render :new, :layout => 'form'
  end

  private

  def to_model_name(param)
    param.split("::").map{|x| x.camelize}.join("::")
  end

  def set_plugin_name
    @plugin_name = "RailsAdmin"
  end

  def check_for_cancel
    if params[:_continue]
      flash[:notice] = "No actions where taken!"
      redirect_to rails_admin_list_path( :model_name => @abstract_model.to_param)
    end
  end

  def list_entries
    @abstract_models = RailsAdmin::AbstractModel.all

    options = {}
    options.merge!(get_sort_hash)
    options.merge!(get_sort_reverse_hash)
    options.merge!(get_query_hash(options))
    options.merge!(get_filter_hash(options))
    per_page = 20 # HAX FIXME

    # per_page = RailsAdmin[:per_page]
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

    @page_name = "Select " + @abstract_model.pretty_name.downcase + " to edit"
    @page_type = @abstract_model.pretty_name.downcase
  end

end
