require 'spec_helper'

describe "RailsAdmin Basic Bulk Delete" do
  describe "bulk_delete" do
    before(:each) do
      @players = 2.times.map { Factory.create :player }
      get rails_admin_bulk_delete_path(:model_name => "player", :bulk_ids => @players.map(&:id))
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it 'should show names of to-be-deleted players' do
      @players.each { |player| response.body.should contain(player.name) }
    end
  end
end
