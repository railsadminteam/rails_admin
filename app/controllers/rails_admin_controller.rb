require 'rails_admin/abstract_model'

class RailsAdminController < ApplicationController
  before_filter :get_model, :except => [:index]
  before_filter :get_object, :only => [:edit, :update, :delete, :destroy]
  before_filter :get_attributes, :only => [:create, :update]
  before_filter :set_plugin_name
  before_filter :check_for_cancel

  def index
    @page_name = "Site administration"
    @page_type = "dashboard"
    
    @abstract_models = MerbAdmin::AbstractModel.all
    render(:layout => 'dashboard')
  end

  def list

    @abstract_models = MerbAdmin::AbstractModel.all
    
    options = {}
    options.merge!(get_sort_hash)
    options.merge!(get_sort_reverse_hash)
    options.merge!(get_query_hash(options))
    options.merge!(get_filter_hash(options))
    per_page = 20 # HAX FIXME
    
    # per_page = MerbAdmin[:per_page]
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
    render :layout => 'list'
  end

  def new
    @object = @abstract_model.new
    
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = MerbAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase
    
    render :layout => 'form'
  end

  def create
    
    @object = @abstract_model.new(@attributes)
    
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = MerbAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase
    
    
    if @object.save && update_all_associations
      redirect_to_on_success
    else
      render_error
    end
    
  end

  def edit
    
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = MerbAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase
    
    render(:layout => 'form')
  end

  def update
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = MerbAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase
    
    update_all_associations
    
    if @object.update_attributes(@attributes) && update_all_associations
      redirect_to_on_success
    else
      render_error
    end
  end

  def delete
    @page_name = action_name.capitalize + " " + @abstract_model.pretty_name.downcase
    @abstract_models = MerbAdmin::AbstractModel.all
    @page_type = @abstract_model.pretty_name.downcase
    
    render(:layout => 'delete')
  end

  def destroy
    @object.destroy
    flash[:notice] = "#{@abstract_model.pretty_name} was successfully destroyed"
    redirect_to rails_admin_list_path(:model_name => @abstract_model.to_param)
  end

  private

  def get_model
    model_name = to_model_name(params[:model_name])
    # FIXME: What method AbstractModel calls? => initialize. 
    @abstract_model = MerbAdmin::AbstractModel.new(model_name)
    @properties = @abstract_model.properties

  end

  def get_object
    @object = @abstract_model.get(params[:id])
    # FIXME
    NotFound unless @object
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
    associated_model = MerbAdmin::AbstractModel.new(association[:child_model])
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
       
    if params[:_add_another]
      flash[:notice] = "#{pretty_name} was successfully #{action}d"
      redirect_to rails_admin_new_path( :model_name => param)
    else
      flash[:notice] = "#{pretty_name} was successfully #{action}d"
      redirect_to rails_admin_list_path(:model_name => param)
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

end