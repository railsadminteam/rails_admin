module RailsAdmin
  class HistoryController < RailsAdmin::ApplicationController
    before_filter :get_model, :only => [:show]

    def list
      if params[:ref].nil? or params[:section].nil?
        not_found
      else
        @history, @current_month = History.get_history_for_month(params[:ref], params[:section])
        render :template => 'rails_admin/main/history', :layout => false
      end
    end

    def show
      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.history.page_name", :name => @model_config.list.label)
      @general = true

      options = {}
      options[:order] = "created_at DESC"
      options[:conditions] = []
      options[:conditions] << "#{History.connection.quote_column_name(:table)} = ?"
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

  end
end
