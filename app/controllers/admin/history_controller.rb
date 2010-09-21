class HistoryController < Admin::BaseController
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
end
