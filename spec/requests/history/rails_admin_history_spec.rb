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

  describe "when range starts in December" do
    it "does not produce SQL with empty IN () range" do
      RailsAdmin::History.should_receive(:find_by_sql).with(["select count(*) as record_count, year, month from rails_admin_histories where month IN (?) and year = ? group by year, month", [1, 2, 3, 4], 2011]).and_return([])
      RailsAdmin::History.get_history_for_dates(12, 4, 2010, 2011)
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
      visit rails_admin_history_list_path(:ref => 0, :section => 4)
      page.should have_no_selector "h1#app_layout_warning"
    end
  end

  describe "model history fetch" do
    before :all do
      @model = RailsAdmin::AbstractModel.new("Player")
      player = FactoryGirl.create :player
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

    it "should respect RailsAdmin::Config.default_items_per_page" do
      RailsAdmin.config.default_items_per_page = 15
      histories = RailsAdmin::AbstractHistory.history_for_model @model, nil, false, false, false, nil
      histories[0].should == 2
      histories[1].all.count.should == 15
    end

    context "GET admin/history/@model" do
      before :each do
        visit rails_admin_history_model_path(@model)
      end

      # https://github.com/sferik/rails_admin/issues/362
      # test that no link uses the "wildcard route" with the history
      # controller and for_model method
      it "should not use the 'wildcard route'" do
        page.should have_selector("a[href*='all=true']") # make sure we're fully testing pagination
        page.should have_no_selector("a[href^='/rails_admin/history/for_model']")
      end

      context "with a lot of histories" do
        before :all do
          player = @model.create(:team_id => -1, :number => -1, :name => "Player 1")
          1000.times do |i|
            player.number = i
            RailsAdmin::AbstractHistory.create_history_item "change #{i}", player, @model, nil
          end
        end

        it "should render a XHR request successfully" do
          xhr :get, rails_admin_history_model_path(@model, :page => 2)
        end
      end
    end
  end

end
