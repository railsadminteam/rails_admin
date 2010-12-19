require 'spec_helper'

describe "RailsAdmin Basic Bulk Destroy" do
  describe "successful bulk delete of records" do
    before(:each) do
      to_delete = []
      to_delete << RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      to_delete << RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 23, :name => "Michael Jackson", :position => "Shooting guard")
      
      get rails_admin_bulk_delete_path(:model_name => "player", :bulk_ids => to_delete.map(&:id))
      
      click_button "Yes, I'm sure"
    end
    
    it "should be successful" do
      response.should be_successful
    end
    
    it "should not contain deleted records" do
      RailsAdmin::AbstractModel.new("Player").count.should == 1
    end
  end
end
