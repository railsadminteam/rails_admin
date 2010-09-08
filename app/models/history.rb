class BlankHistory
  attr_accessor :number, :month, :year, :fake
  def initialize
    @number = 0
    @month = "No data"
    @year = "for this month"
    @fake = 1
  end
end

class History < ActiveRecord::Base

  def self.paginated(options = {})
    page = options.delete(:page) || 1
    per_page = options.delete(:per_page) || RailsAdmin[:per_page]

    page_count = (count(options).to_f / per_page).ceil

    options.merge!({
      :limit => per_page,
      :offset => (page - 1) * per_page
    })

    [page_count, all(options)]
  end

  def self.latest
    mstart = 5.month.ago.month
    mstop = Time.now.month

    ystop = Time.now.year
    ystart = 5.month.ago.year

    self.get_history_for_dates(mstart,mstop,ystart,ystop)
  end


  def self.get_history_for_dates(mstart,mstop,ystart,ystop)
    sql_in = ""
    if mstart > mstop
      sql_in = (mstart+1..12).to_a.join(", ")
      sql_in_two = (1..mstop).to_a.join(", ")

      results = History.find_by_sql("select count(*) as number, year, month from histories where month IN (#{sql_in}) and year = #{ystart} group by year, month")
      results_two = History.find_by_sql("select count(*) as number, year, month from histories where month IN (#{sql_in_two}) and year = #{ystop} group by year, month")

      results.concat(results_two)
    else
      sql_in =  (mstart+1..mstop).to_a.join(", ")

      results = History.find_by_sql("select count(*) as number, year, month from histories where month IN (#{sql_in}) and year = #{ystart} group by year, month")
    end

    return self.add_blank_results(results)
  end

  def self.add_blank_results(results)
    if results.size < 5
      empty_results_count = 5 - results.size
      empty_results = []

      empty_results_count.times do |t|
        empty_results << BlankHistory.new()
      end

      return empty_results.concat(results)

    else
      return results
    end
  end

  def self.get_history_for_month(ref,section)
    # blah
    current_ref = -5 * ref.to_i
    current_diff = current_ref + 5 - (section.to_i+1)

    current_month = current_diff.month.ago

    return History.find(:all, :conditions => ["month = ? and year = ?", current_month.month, current_month.year]), current_month
  end
end
