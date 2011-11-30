module RailsAdmin

  class MainController < RailsAdmin::ApplicationController
    include ActionView::Helpers::TextHelper
    
    layout "rails_admin/application"

    before_filter :get_model, :except => [:dashboard]
    before_filter :get_object, :only => [:show, :edit, :update, :delete, :destroy]
    before_filter :get_attributes, :only => [:create, :update]
    before_filter :check_for_cancel, :only => [:create, :update, :destroy, :export, :bulk_destroy]

    def dashboard
      @page_name = t("admin.dashboard.pagename")
      @page_type = "dashboard"

      @history = History.latest
      @abstract_models = RailsAdmin::Config.visible_models.map(&:abstract_model)

      @most_recent_changes = {}
      @count = {}
      @max = 0
      @abstract_models.each do |t|
        scope = @authorization_adapter && @authorization_adapter.query(:index, t)
        current_count = t.count({}, scope)
        @max = current_count > @max ? current_count : @max
        @count[t.pretty_name] = current_count
        @most_recent_changes[t.pretty_name] = t.model.order("updated_at desc").first.try(:updated_at) rescue nil
      end
      render :dashboard
    end

    def index
      @authorization_adapter.authorize(:index, @abstract_model) if @authorization_adapter

      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.index.select", :name => @model_config.label.downcase)

      @objects ||= list_entries

      respond_to do |format|
        format.html { render :layout => !request.xhr? }
        format.json do
          output = if params[:compact]
            @objects.map{ |o| { :id => o.id, :label => o.send(@model_config.object_label_method) } }
          else
            @objects.to_json(@schema)
          end
          if params[:send_data]
            send_data output, :filename => "#{params[:model_name]}_#{DateTime.now.strftime("%Y-%m-%d_%Hh%Mm%S")}.json"
          else
            render :json => output
          end
        end
        format.xml do
          output = @objects.to_xml(@schema)
          if params[:send_data]
            send_data output, :filename => "#{params[:model_name]}_#{DateTime.now.strftime("%Y-%m-%d_%Hh%Mm%S")}.xml"
          else
            render :xml => output
          end
        end
        format.csv do
          header, encoding, output = CSVConverter.new(@objects, @schema).to_csv(params[:csv_options])
          if params[:send_data]
            send_data output,
              :type => "text/csv; charset=#{encoding}; #{"header=present" if header}",
              :disposition => "attachment; filename=#{params[:model_name]}_#{DateTime.now.strftime("%Y-%m-%d_%Hh%Mm%S")}.csv"
          else
            render :text => output
          end
        end
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
      if object_params = params[@abstract_model.to_param]
        @object.set_attributes(@object.attributes.merge(object_params), _attr_accessible_role)
      end
      @page_name = t("admin.actions.create").capitalize + " " + @model_config.label.downcase
      @page_type = @abstract_model.pretty_name.downcase
      respond_to do |format|
        format.html
        format.js   { render :layout => false }
      end
    end

    def create
      @modified_assoc = []
      @object = @abstract_model.new
      @model_config.create.fields.each {|f| f.parse_input(@attributes) if f.respond_to?(:parse_input) }
      if @authorization_adapter
        @authorization_adapter.attributes_for(:create, @abstract_model).each do |name, value|
          @object.send("#{name}=", value)
        end
        @authorization_adapter.authorize(:create, @abstract_model, @object)
      end
      @object.set_attributes(@attributes, _attr_accessible_role)
      @page_name = t("admin.actions.create").capitalize + " " + @model_config.label.downcase
      @page_type = @abstract_model.pretty_name.downcase

      if @object.save
        History.create_history_item("Created #{@model_config.with(:object => @object).object_label}", @object, @abstract_model, _current_user)
        respond_to do |format|
          format.html do
            redirect_to_on_success
          end
          format.js do
            render :json => {
              :id => @object.id,
              :label => @model_config.with(:object => @object).object_label,
            }
          end
        end
      else
        handle_save_error
      end
    end

    def show
      @authorization_adapter.authorize(:show, @abstract_model, @object) if @authorization_adapter
      @page_name = t("admin.show.page_name", :name => "#{@model_config.label.downcase} '#{@object.send(@model_config.object_label_method)}'")
      @page_type = @abstract_model.pretty_name.downcase
    end

    def edit
      @authorization_adapter.authorize(:edit, @abstract_model, @object) if @authorization_adapter
      @page_name = "#{t("admin.actions.update").capitalize} #{@model_config.label.downcase} '#{@object.send(@model_config.object_label_method)}'"
      @page_type = @abstract_model.pretty_name.downcase
      respond_to do |format|
        format.html
        format.js   { render :layout => false }
      end
    end

    def update
      @authorization_adapter.authorize(:update, @abstract_model, @object) if @authorization_adapter

      @cached_assocations_hash = associations_hash
      @modified_assoc = []

      @page_name = "#{t("admin.actions.update").capitalize} #{@model_config.label.downcase} '#{@object.send(@model_config.object_label_method)}'"
      @page_type = @abstract_model.pretty_name.downcase

      @old_object = @object.dup
      @model_config.update.fields.map {|f| f.parse_input(@attributes) if f.respond_to?(:parse_input) }
      @object.set_attributes(@attributes, _attr_accessible_role)

      if @object.save
        History.create_update_history @abstract_model, @object, @cached_assocations_hash, associations_hash, @modified_assoc, @old_object, _current_user
        respond_to do |format|
          format.html do
            redirect_to_on_success
          end
          format.js do
            render :json => {
              :id => @object.id,
              :label => @model_config.with(:object => @object).object_label,
            }
          end
        end
      else
        handle_save_error :edit
      end
    end

    def delete
      @authorization_adapter.authorize(:delete, @abstract_model, @object) if @authorization_adapter
      @page_name = "#{t("admin.actions.delete").capitalize} #{@model_config.label.downcase} '#{@object.send(@model_config.object_label_method)}'"
      @page_type = @abstract_model.pretty_name.downcase
      respond_to do |format|
        format.html
        format.js   { render :layout => false }
      end
    end

    def destroy
      @authorization_adapter.authorize(:destroy, @abstract_model, @object) if @authorization_adapter

      if @abstract_model.destroy(@object)
        History.create_history_item("Destroyed #{@model_config.with(:object => @object).object_label}", @object, @abstract_model, _current_user)
        flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.deleted"))
      else
        flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.deleted"))
      end

      redirect_to back_or_index
    end

    def export
      # todo
      #   limitation: need to display at least one real attribute ('only') so that the full object doesn't get displayed, a way to fix this? maybe force :only => [""]
      #   use send_file instead of send_data to leverage the x-sendfile header set by rails 3 (generate and let the front server handle the rest)
      # maybe
      #   n-levels (backend: possible with xml&json, frontend: not possible?)
      @authorization_adapter.authorize(:export, @abstract_model) if @authorization_adapter

      if format = params[:json] && :json || params[:csv] && :csv || params[:xml] && :xml
        request.format = format
        @schema = params[:schema].symbolize if params[:schema] # to_json and to_xml expect symbols for keys AND values.
        @objects = list_entries(@model_config, :export)
        index
      else
        @page_name = t("admin.actions.export").capitalize + " " + @model_config.label_plural.downcase
        @page_type = @abstract_model.pretty_name.downcase

        render :action => 'export'
      end
    end

    def bulk_action
      redirect_to :back, :flash => { :info => t("admin.flash.noaction") } and return if params[:bulk_ids].blank?
      case params[:bulk_action]
      when "delete" then bulk_delete
      when "export" then export
      else raise "#{params[:bulk_action]} not implemented"
      end
    end

    def bulk_delete
      @authorization_adapter.authorize(:bulk_delete, @abstract_model) if @authorization_adapter
      @page_name = t("admin.actions.delete").capitalize + " " + @model_config.label.downcase
      @page_type = @abstract_model.pretty_name.downcase
      @objects = list_entries(@model_config, :destroy)
      not_found and return if @objects.empty?

      render :action => 'bulk_delete'
    end

    def bulk_destroy
      @authorization_adapter.authorize(:bulk_destroy, @abstract_model) if @authorization_adapter
      @objects = list_entries(@model_config, :destroy)
      processed_objects = @abstract_model.destroy(@objects)

      destroyed = processed_objects.select(&:destroyed?)
      not_destroyed = processed_objects - destroyed

      destroyed.each do |object|
        message = "Destroyed #{@model_config.with(:object => object).object_label}"
        History.create_history_item(message, object, @abstract_model, _current_user)
      end

      unless destroyed.empty?
        flash[:success] = t("admin.flash.successful", :name => pluralize(destroyed.count, @model_config.label), :action => t("admin.actions.deleted"))
      end

      unless not_destroyed.empty?
        flash[:error] = t("admin.flash.error", :name => pluralize(not_destroyed.count, @model_config.label), :action => t("admin.actions.deleted"))
      end

      redirect_to back_or_index
    end

    def list_entries(model_config = @model_config, auth_scope_key = :index, additional_scope = get_association_scope_from_params, pagination = !(params[:associated_collection] || params[:all]))
      scope = @authorization_adapter && @authorization_adapter.query(auth_scope_key, model_config.abstract_model)
      scope = model_config.abstract_model.scoped.merge(scope)
      scope = scope.instance_eval(&additional_scope) if additional_scope
      
      get_collection(model_config, scope, pagination)
    end

    private
    
    def back_or_index
      params[:return_to].presence && params[:return_to].include?(request.host) && (params[:return_to] != request.fullpath) ? params[:return_to] : index_path
    end

    def get_sort_hash(model_config)
      abstract_model = model_config.abstract_model
      params[:sort] = params[:sort_reverse] = nil unless model_config.list.with(:view => self, :object => abstract_model.model.new).visible_fields.map {|f| f.name.to_s}.include? params[:sort]

      params[:sort] ||= model_config.list.sort_by.to_s
      params[:sort_reverse] ||= 'false'

      field = model_config.list.fields.find{ |f| f.name.to_s == params[:sort] }

      column = if field.nil? || field.sortable == true # use params[:sort] on the base table
        "#{abstract_model.model.table_name}.#{params[:sort]}"
      elsif field.sortable == false # use default sort, asked field is not sortable
        "#{abstract_model.model.table_name}.#{model_config.list.sort_by}"
      elsif field.sortable.is_a?(String) && field.sortable.include?('.') # just provide sortable, don't do anything smart
        field.sortable
      elsif field.sortable.is_a?(Hash) # just join sortable hash, don't do anything smart
        "#{field.sortable.keys.first}.#{field.sortable.values.first}"
      elsif field.association? # use column on target table
        "#{field.associated_model_config.abstract_model.model.table_name}.#{field.sortable}"
      else # use described column in the field conf.
        "#{abstract_model.model.table_name}.#{field.sortable}"
      end

      reversed_sort = (field ? field.sort_reverse? : model_config.list.sort_reverse?)
      {:sort => column, :sort_reverse => (params[:sort_reverse] == reversed_sort.to_s)}
    end


    def get_attributes
      @attributes = params[@abstract_model.to_param.singularize.gsub('~','_')] || {}
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
      notice = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.#{params[:action]}d"))
      if params[:_add_another]
        redirect_to new_path(:return_to => params[:return_to]), :flash => { :success => notice }
      elsif params[:_add_edit]
        redirect_to edit_path(:id => @object.id, :return_to => params[:return_to]), :flash => { :success => notice }
      else
        redirect_to back_or_index, :flash => { :success => notice }
      end
    end

    def handle_save_error whereto = :new
      action = params[:action]

      flash.now[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.#{action}d"))
      flash.now[:error] += ". #{@object.errors[:base].to_sentence}" unless @object.errors[:base].blank?

      respond_to do |format|
        format.html { render whereto, :status => :not_acceptable }
        format.js   { render whereto, :layout => false, :status => :not_acceptable  }
      end
    end

    def check_for_cancel
      redirect_to back_or_index, :flash => { :info => t("admin.flash.noaction") } if params[:_continue]
    end

    def get_collection(model_config, scope, pagination)
      associations = model_config.list.fields.select {|f| f.type == :belongs_to_association && !f.polymorphic? }.map {|f| f.association[:name] }
      options = {}
      options = options.merge(:page => (params[:page] || 1).to_i, :per => (params[:per] || model_config.list.items_per_page)) if pagination
      options = options.merge(:include => associations) unless associations.blank?
      options = options.merge(get_sort_hash(model_config)) unless params[:associated_collection]
      options = options.merge(model_config.abstract_model.get_conditions_hash(model_config, params[:query], params[:f])) if (params[:query].present? || params[:f].present?)
      options = options.merge(:bulk_ids => params[:bulk_ids]) if params[:bulk_ids]

      objects = model_config.abstract_model.all(options, scope)
    end

    def get_association_scope_from_params
      return nil unless params[:associated_collection].present?
      source_abstract_model = RailsAdmin::AbstractModel.new(to_model_name(params[:source_abstract_model]))
      source_model_config = RailsAdmin.config(source_abstract_model)
      source_object = source_abstract_model.get(params[:source_object_id])
      action = params[:current_action].in?(['create', 'update']) ? params[:current_action] : 'edit'
      association = source_model_config.send(action).fields.find{|f| f.name == params[:associated_collection].to_sym }.with(:controller => self, :object => source_object)
      association.associated_collection_scope
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
