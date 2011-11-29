require 'spec_helper'

describe "RailsAdmin History" do
  
  
  describe "model history fetch" do
    before :each do
      @model = RailsAdmin::AbstractModel.new("Player")
      player = FactoryGirl.create :player
      30.times do |i|
        player.number = i
        RailsAdmin::History.create_history_item "change #{i}", player, @model, nil
      end
    end

    it "should fetch one page of history" do
      histories = RailsAdmin::History.history_for_model @model, nil, false, false, false, nil, 20
      histories.total_count.should == 30
      histories.count.should == 20
    end
    
    it "should respect RailsAdmin::Config.default_items_per_page" do
      RailsAdmin.config.default_items_per_page = 15
      histories = RailsAdmin::History.history_for_model @model, nil, false, false, false, nil
      histories.total_count.should == 30
      histories.count.should == 15
    end

    context "GET admin/history/@model" do
      before :each do
        visit history_model_path(@model)
      end

      # https://github.com/sferik/rails_admin/issues/362
      # test that no link uses the "wildcard route" with the history
      # controller and for_model method
      it "should not use the 'wildcard route'" do
        page.should have_selector("a[href*='all=true']") # make sure we're fully testing pagination
        page.should have_no_selector("a[href^='/rails_admin/history/for_model']")
      end

      context "with a lot of histories" do
        before :each do
          player = @model.create(:team_id => -1, :number => -1, :name => "Player 1")
          101.times do |i|
            player.number = i
            RailsAdmin::History.create_history_item "change #{i}", player, @model, nil
          end
        end
        
        it 'should get latest ones' do
          RailsAdmin::History.latest.count.should == 100
        end

        it "should render a XHR request successfully" do
          xhr :get, history_model_path(@model, :page => 2)
        end
      end
    end
  end

end
