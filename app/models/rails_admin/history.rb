module RailsAdmin
  class History < ActiveRecord::Base
    set_table_name :rails_admin_histories

    IGNORED_ATTRS = Set[:id, :created_at, :created_on, :deleted_at, :updated_at, :updated_on, :deleted_on]

    scope :most_recent, lambda {|model|
      where("#{retrieve_connection.quote_column_name(:table)} = ?", model.pretty_name).order("updated_at DESC")
    }

    before_save :truncate_message

    def truncate_message
      if message.present? && message.size > 255
        self.message = message.truncate(255)
      end
    end

    def self.get_history_for_dates(mstart, mstop, ystart, ystop)
      if mstart > mstop && mstart < 12
        results = History.find_by_sql(["select count(*) as record_count, year, month from rails_admin_histories where month IN (?) and year = ? group by year, month",
                                      ((mstart + 1)..12).to_a, ystart])
        results_two = History.find_by_sql(["select count(*) as number, year, month from rails_admin_histories where month IN (?) and year = ? group by year, month",
                                          (1..mstop).to_a, ystop])

        results.concat(results_two)
      else
        results = History.find_by_sql(["select count(*) as record_count, year, month from rails_admin_histories where month IN (?) and year = ? group by year, month",
                                      ((mstart == 12 ? 1 : mstart + 1)..mstop).to_a, ystop])
      end

      results.each do |result|
        result.record_count = result.record_count.to_i
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
