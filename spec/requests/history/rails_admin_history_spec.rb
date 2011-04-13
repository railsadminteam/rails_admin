require 'spec_helper'

describe "RailsAdmin History" do

  describe "handle nil results" do
    before(:each) do
      @months = RailsAdmin::History.add_blank_results([], 5, 2010)
    end

    it "should pad the correct number of months" do
      @months.length.should == 5
      @months.map(&:month).should == [6, 7, 8, 9, 10]
    end
  end

  describe "history blank results single year" do
    before(:each) do
      @months = RailsAdmin::History.add_blank_results([RailsAdmin::BlankHistory.new(7, 2010), RailsAdmin::BlankHistory.new(9, 2011)], 5, 2010)
    end

    it "should pad the correct number of months" do
      @months.length.should == 5
    end

    it "should pad at the beginning" do
      @months.map(&:month).should == [6, 7, 8, 9, 10]
    end
  end

  describe "history blank results wraparound" do
    before(:each) do
      @months = RailsAdmin::History.add_blank_results([RailsAdmin::BlankHistory.new(12, 2010), RailsAdmin::BlankHistory.new(2, 2011)], 10, 2010)
    end

    it "should pad at the beginning" do
      @months.map(&:month).should == [11, 12, 1, 2, 3]
    end

    it "should handle year-to-year rollover" do
      @months.map(&:year).should == [2010, 2010, 2011, 2011, 2011]
    end
  end

  describe "history ajax update" do
    it "shouldn't use the application layout" do
      post rails_admin_history_list_path, :ref => 0, :section => 4
      response.should_not have_tag "h1#app_layout_warning"
    end
  end

  describe "model history fetch" do
    before :all do
      @default_items_per_page = RailsAdmin::Config::Sections::List.default_items_per_page
      @model = RailsAdmin::AbstractModel.new("Player")
      player = Factory.create :player
      30.times do |i|
        player.number = i
        RailsAdmin::AbstractHistory.create_history_item "change #{i}", player, @model, nil
      end
    end

    it "should fetch one page of history" do
      histories = RailsAdmin::AbstractHistory.history_for_model @model, nil, false, false, false, nil, 20
      histories[0].should == 2
      histories[1].all.count.should == 20
    end

    it "should respect RailsAdmin::Config::Sections::List.default_items_per_page" do
      RailsAdmin::Config::Sections::List.default_items_per_page = 15
      histories = RailsAdmin::AbstractHistory.history_for_model @model, nil, false, false, false, nil
      histories[0].should == 2
      histories[1].all.count.should == 15
    end

    context "GET admin/history/@model" do
      before :each do
        get rails_admin_history_model_path(@model)
      end

      it "should render successfully" do
        response.should be_successful
      end

      context "with a lot of histories" do
        before :all do
          player = @model.create(:team_id => -1, :number => -1, :name => "Player 1")
          1000.times do |i|
            player.number = i
            RailsAdmin::AbstractHistory.create_history_item "change #{i}", player, @model, nil
          end
        end

        it "should render successfully" do
          response.should be_successful
        end

        it "should render a XHR request successfully" do
          xhr :get, rails_admin_history_model_path(@model, :page => 2)
          response.should be_successful
        end
      end
    end

    after :all do
      RailsAdmin::Config::Sections::List.default_items_per_page = @default_items_per_page
    end
  end

end
