require 'spec_helper'

describe "RailsAdmin Basic Bulk Delete" do
  describe "bulk_delete" do
    before(:each) do
      players = []
      players << RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      players << RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 23, :name => "Player 2")
    
      get rails_admin_bulk_delete_path(:model_name => "player", :bulk_ids => players.map(&:id))
    end
    
    it "should respond successfully" do
      response.should be_successful
    end
    
    it 'should show names of to-be-deleted players' do
      response.body.should contain("Player 1")
      response.body.should contain("Player 2")
    end
  end
end
