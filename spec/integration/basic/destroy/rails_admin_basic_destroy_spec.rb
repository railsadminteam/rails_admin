require 'spec_helper'

describe "RailsAdmin Basic Destroy" do

  subject { page }

  describe "destroy" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit delete_path(:model_name => "player", :id => @player.id)
      click_button "Yes, I'm sure"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should destroy an object" do
      @player.should be_nil
    end

    it "should show success message" do
      should have_content('Player successfully deleted')
    end
  end

  describe "handle destroy errors" do
    before(:each) do
      Player.any_instance.stub(:destroy_hook).and_return false
      @player = FactoryGirl.create :player
      visit delete_path(:model_name => "player", :id => @player.id)
      click_button "Yes, I'm sure"
    end

    it "should not destroy an object" do
      @player.reload.should be
    end

    it "should show error message" do
      should have_content('Player failed to be deleted')
    end
  end

  describe "destroy" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit delete_path(:model_name => "player", :id => @player.id)
      click_button "Cancel"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should not destroy an object" do
      @player.should be
    end
  end

  describe "destroy with missing object" do
    before(:each) do
      page.driver.delete(delete_path(:model_name => "player", :id => 1))
    end

    it "should raise NotFound" do
      page.driver.status_code.should eql(404)
    end
  end

  describe 'destroy from show page' do
    it 'should redirect to the index instead of trying to show the deleted object' do
      @player = FactoryGirl.create :player
      visit show_path(:model_name => 'player', :id => @player.id)
      visit delete_path(:model_name => "player", :id => @player.id)
      click_button "Yes, I'm sure"

      URI.parse(page.current_url).path.should ==(index_path(:model_name => 'player'))
    end

    it 'should redirect back to the object on error' do
      Player.any_instance.stub(:destroy_hook).and_return false
      @player = FactoryGirl.create :player
      visit show_path(:model_name => 'player', :id => @player.id)
      visit delete_path(:model_name => "player", :id => @player.id)
      click_button "Yes, I'm sure"

      URI.parse(page.current_url).path.should ==(show_path(:model_name => 'player', :id => @player.id))
    end
  end
end
