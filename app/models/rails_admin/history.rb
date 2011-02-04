module RailsAdmin
  class History < ActiveRecord::Base
    set_table_name :rails_admin_histories

    IGNORED_ATTRS = Set[:id, :created_at, :created_on, :deleted_at, :updated_at, :updated_on, :deleted_on]

    scope :most_recent, lambda {|table|
      where("#{retrieve_connection.quote_column_name(:table)} = ?", table).order("updated_at")
    }

    def self.get_history_for_dates(mstart, mstop, ystart, ystop)
      sql_in = ""
      if mstart > mstop
        sql_in = (mstart + 1..12).to_a.join(", ")
        sql_in_two = (1..mstop).to_a.join(", ")

        results = History.find_by_sql("select count(*) as number, year, month from rails_admin_histories where month IN (#{sql_in}) and year = #{ystart} group by year, month")
        results_two = History.find_by_sql("select count(*) as number, year, month from rails_admin_histories where month IN (#{sql_in_two}) and year = #{ystop} group by year, month")

        results.concat(results_two)
      else
        sql_in =  (mstart + 1..mstop).to_a.join(", ")

        results = History.find_by_sql("select count(*) as number, year, month from rails_admin_histories where month IN (#{sql_in}) and year = #{ystart} group by year, month")
      end

      results.each do |result|
        result.number = result.number.to_i
      end

      add_blank_results(results, mstart, ystart)
    end

    def self.add_blank_results(results, mstart, ystart)
      # fill in an array with BlankHistory
      blanks = Array.new(5) { |i| BlankHistory.new(((mstart+i) % 12)+1, ystart + ((mstart+i)/12)) }
      # replace BlankHistory array entries with the real History entries that were provided
      blanks.each_index do |i|
        if results[0] && results[0].year == blanks[i].year && results[0].month == blanks[i].month
          blanks[i] = results.delete_at 0
        end
      end
    end
  end
end
