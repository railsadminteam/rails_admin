module RailsAdmin
  class BlankHistory
    attr_accessor :number, :month, :year, :fake
    def initialize
      @number = 0
      @month = "No data"
      @year = "for this month"
      @fake = 1
    end
  end
end
