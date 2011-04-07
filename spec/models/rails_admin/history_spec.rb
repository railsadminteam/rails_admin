require 'spec_helper'

describe RailsAdmin::History do
  context "from the beginning of the year" do
    before do
      @results = RailsAdmin::History.get_history_for_dates(12, 4, 2010, 2011)
    end

    it "should get history" do
      @results.count.should == 5
    end
  end
end
