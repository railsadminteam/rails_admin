require 'rails_admin/abstract_model'

class HistoryController < ApplicationController
  before_filter :_authenticate!
  before_filter :_authorize!
  before_filter :set_plugin_name

  def show
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

  def list
    if params[:ref].nil? or params[:section].nil?
      not_found
    else
      @history, @current_month = History.get_history_for_month(params[:ref], params[:section])
      render :template => 'rails_admin/history'
    end
  end

  private

  def _authenticate!
    instance_eval &RailsAdmin.authenticate_with
  end

  def _authorize!
    instance_eval &RailsAdmin.authorize_with
  end

  def set_plugin_name
    @plugin_name = "RailsAdmin"
  end

  def not_found
    render :file => Rails.root.join('public', '404.html'), :layout => false, :status => 404
  end
end
