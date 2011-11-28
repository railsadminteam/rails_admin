module RailsAdmin
  class HistoryController < RailsAdmin::ApplicationController
    before_filter :get_model
    before_filter :get_object, :except => :for_model

    def for_model
      @authorization_adapter.authorize(:history) if @authorization_adapter
      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.history.page_name", :name => @model_config.label.downcase)
      @general = true
      @history = History.history_for_model(@abstract_model, params[:query], params[:sort], params[:sort_reverse], params[:all], params[:page])

      render "show", :layout => request.xhr? ? false : 'rails_admin/application'
    end

    def for_object
      @authorization_adapter.authorize(:history) if @authorization_adapter
      @page_type = @abstract_model.pretty_name.downcase
      @page_name = t("admin.history.page_name", :name => "#{@model_config.label.downcase} '#{@model_config.with(:object => @object).object_label}'")
      @general = false
      @history = History.history_for_object(@abstract_model, @object, params[:query], params[:sort], params[:sort_reverse], params[:all], params[:page])

      render "show", :layout => request.xhr? ? false : 'rails_admin/application'
    end
  end
end
