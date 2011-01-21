module RailsAdmin
  class BlankHistory
    attr_accessor :number, :month, :year
    def initialize(month, year)
      @number = 0
      @month = month
      @year = year
    end

    # Make BlankHistory look like History when it gets JSON-serialized.
    def to_hash(*a)
      {"history" => {"number" => @number, "month" => @month, "year" => @year}}
    end

  end
end
