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
  
  describe "creating a new history entry" do
    it "saves up to 255 chars without modification" do
      history = RailsAdmin::History.create(:message => "#"*255).reload
      
      history.message.should == "#"*255
    end
    
    it "messages longer than 255 chars are truncated" do
      history = RailsAdmin::History.create(:message => "#"*280).reload
      
      history.message.should == ("#"*(255-3))+"..."
    end
  end
end
