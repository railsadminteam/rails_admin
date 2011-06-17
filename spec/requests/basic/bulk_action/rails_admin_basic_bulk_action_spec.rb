require 'spec_helper'

describe "RailsAdmin Basic Bulk Action" do
  describe "bulk_delete" do
    before(:each) do
      @players = 2.times.map { FactoryGirl.create :player }
      post rails_admin_bulk_action_path(:bulk_delete => '', :model_name => "player", :bulk_ids => @players.map(&:id))
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it 'should show names of to-be-deleted players' do
      @players.each { |player| response.body.should contain(player.name) }
    end
  end
  
  describe "bulk_export" do
    before(:each) do
      @players = 2.times.map { FactoryGirl.create :player }
      post rails_admin_bulk_action_path(:bulk_export => '', :model_name => "player", :bulk_ids => @players.map(&:id))
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it 'should show form for export' do
      @players.each { |player| response.body.should contain("Select fields to export") }
    end
  end
end
