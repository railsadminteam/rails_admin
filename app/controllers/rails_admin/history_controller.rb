module RailsAdmin
  class HistoryController < RailsAdmin::ApplicationController
    before_filter :get_model, :except => [:list, :slider]
    before_filter :get_object, :except => [:list, :slider, :for_model]

    def list
      if params[:month].nil? or params[:year].nil?
        not_found
      else
        @month = params[:month].to_i
        @year = params[:year].to_i
        @history = AbstractHistory.history_for_month(@month, @year)
        render :template => 'rails_admin/main/history', :layout => false
      end
    end

    def slider
      if params[:from].blank? or params[:to].blank?
        not_found
      else
        render :json => AbstractHistory.history_summaries(params[:from], params[:to])
      end
    end

    def for_model
      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.history.page_name", :name => @model_config.label)
      @general = true
      @current_page = params[:page].try(:to_i) || 1

      @page_count, @history = AbstractHistory.history_for_model @abstract_model, params[:query], params[:sort], params[:sort_reverse], params[:all], params[:page]

      render "show", :layout => request.xhr? ? false : 'rails_admin/main'
    end

    def for_object
      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.history.page_name", :name => @model_config.with(:object => @object).object_label)
      @general = false

      @history = AbstractHistory.history_for_object @abstract_model, @object, params[:query], params[:sort], params[:sort_reverse]

      render "show", :layout => request.xhr? ? false : 'rails_admin/main'
    end

  end
end
