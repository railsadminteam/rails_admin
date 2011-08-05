module RailsAdmin
  class BlankHistory
    attr_accessor :record_count, :month, :year
    def initialize(month, year)
      @record_count = 0
      @month = month
      @year = year
    end

    # Make BlankHistory look like History when it gets JSON-serialized.
    def to_hash(*a)
      {"history" => {"record_count" => @record_count, "month" => @month, "year" => @year}}
    end
  end
end
