module RailsAdmin
  class HistoryController < ApplicationController
    def list
      if params[:ref].nil? or params[:section].nil?
        not_found
      else
        @history, @current_month = History.get_history_for_month(params[:ref], params[:section])
        render :template => 'rails_admin/main/history', :layout => false
      end
    end
  end
end
