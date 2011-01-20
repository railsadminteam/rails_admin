require "rails_admin/abstract_history"

module RailsAdmin
  class HistoryController < RailsAdmin::ApplicationController
    before_filter :get_model, :except => [:list, :slider]
    before_filter :get_object, :except => [:list, :slider, :for_model]

    def list
      if params[:ref].nil? or params[:section].nil?
        not_found
      else
        @history, @current_month = RailsAdmin.history_for_month(params[:ref], params[:section])
        render :template => 'rails_admin/main/history', :layout => false
      end
    end

    def slider
      ref = params[:ref].to_i

      if ref.nil? or ref > 0
        not_found
      else
        render :json => RailsAdmin.history_summaries(ref)
      end
    end

    def for_model
      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.history.page_name", :name => @model_config.list.label)
      @general = true

      @page_count, @history = RailsAdmin.history_for_model @abstract_model, params[:query], params[:sort], params[:sort_reverse], params[:all], params[:page]

      render "show", :layout => request.xhr? ? false : 'rails_admin/list'
    end

    def for_object
      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.history.page_name", :name => @model_config.bind(:object, @object).list.object_label)
      @general = false

      @history = RailsAdmin.history_for_object @abstract_model, @object, params[:query], params[:sort], params[:sort_reverse]

      render "show", :layout => request.xhr? ? false : 'rails_admin/list'
    end

  end
end
