require 'spec_helper'

describe "RailsAdmin History", :active_record => true do
  describe "model history fetch" do
    before :each do
      RailsAdmin::History.delete_all
      @model = RailsAdmin::AbstractModel.new("Player")
      player = FactoryGirl.create :player
      30.times do |i|
        player.number = i
        RailsAdmin::History.create_history_item "change #{i}", player, @model, nil
      end
    end

    it "fetches on page of history" do
      histories = RailsAdmin::History.history_for_model @model, nil, false, false, false, nil, 20
      expect(histories.total_count).to eq(30)
      expect(histories.count).to eq(20)
    end

    it "respects RailsAdmin::Config.default_items_per_page" do
      RailsAdmin.config.default_items_per_page = 15
      histories = RailsAdmin::History.history_for_model @model, nil, false, false, false, nil
      expect(histories.total_count).to eq(30)
      expect(histories.count).to eq(15)
    end

    context "with Kaminari" do
      before do
        Kaminari.config.page_method_name = :per_page_kaminari
        @paged = RailsAdmin::History.page(1)
      end

      after do
        Kaminari.config.page_method_name = :page
      end

      it "supports pagination when Kaminari's page_method_name is customized" do
        RailsAdmin::History.should_receive(:per_page_kaminari).twice.and_return(@paged)
        RailsAdmin::History.history_for_model @model, nil, false, false, false, nil
        RailsAdmin::History.history_for_object @model, Player.first, nil, false, false, false, nil
      end
    end

    context "GET admin/history/@model" do
      before :each do
        RailsAdmin.config do |c|
          c.audit_with :history
        end

        visit history_index_path(@model)
      end

      # https://github.com/sferik/rails_admin/issues/362
      # test that no link uses the "wildcard route" with the history
      # controller and for_model method
      it "does not use the 'wildcard route'" do
        expect(page).to have_selector("a[href*='all=true']") # make sure we're fully testing pagination
        expect(page).to have_no_selector("a[href^='/rails_admin/history/for_model']")
      end

      context "with a lot of histories" do
        before :each do
          player = Player.create(:team_id => -1, :number => -1, :name => "Player 1")
          101.times do |i|
            player.number = i
            RailsAdmin::History.create_history_item "change #{i}", player, @model, nil
          end
        end

        it "gets latest ones" do
          expect(RailsAdmin::History.latest.count).to eq(100)
        end

        it "gets latest ones orderly" do
          latest = RailsAdmin::History.latest
          expect(latest.first.message).to eq("change 100")
          expect(latest.last.message).to eq("change 1")
        end

        it "renders a XHR request successfully" do
          xhr :get, history_index_path(@model, :page => 2)
        end
      end
    end
  end

end
