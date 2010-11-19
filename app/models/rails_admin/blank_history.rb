module RailsAdmin
  class BlankHistory
    attr_accessor :number, :month, :year
    def initialize(month, year)
      @number = 0
      @month = month
      @year = year
    end
  end
end
