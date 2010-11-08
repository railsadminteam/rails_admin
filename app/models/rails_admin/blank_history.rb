module RailsAdmin
  class BlankHistory
    attr_accessor :number, :month, :year, :fake
    def initialize(month, year)
      @number = 0
      @month = month
      @year = year
      @fake = 1
    end
  end
end
