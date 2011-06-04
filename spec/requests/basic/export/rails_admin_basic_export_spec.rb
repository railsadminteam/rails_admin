require 'spec_helper'

describe "RailsAdmin Export" do
  
  before(:each) do
    Comment.all.map &:destroy # rspec bug => doesn't get destroyed with transaction

    @players = 4.times.map { FactoryGirl.create :player }
    @player = @players.first
    @player.team = FactoryGirl.create :team
    @player.draft = FactoryGirl.create :draft
    @player.comments = (@comments = 2.times.map { FactoryGirl.create(:comment) })
    @player.save
    
    # removed schema=>only=>created_at
    @non_default_schema = {
      "only"=>["id", "updated_at", "deleted_at", "name", "position", "number", "retired", "injured", "born_on", "notes", "suspended"],  
      "include"=>{
        "team"=>{"only"=>["id", "created_at", "updated_at", "name", "logo_url", "manager", "ballpark", "mascot", "founded", "wins", "losses", "win_percentage", "revenue", "color"]}, 
        "draft"=>{"only"=>["id", "created_at", "updated_at", "date", "round", "pick", "overall", "college", "notes"]}, 
        "comments"=>{"only"=>["id", "content", "created_at", "updated_at"]}
      }
    }
  end
    
  describe "POST /admin/players/export (prompt)" do
    
    it "should allow to export to CSV with associations and default schema, containing properly translated header" do
      post rails_admin_export_path(:model_name => 'player')
      response.should be_successful
      response.body.should contain 'Select fields to export'
      select "<comma> ','", :from => "csv_options_generator_col_sep"
      click_button 'Export to csv'
      response.should be_successful
      response.body.should contain "Id,Created at,Updated at,Deleted at,Name,Position,Number,Retired,Injured,Born on,Notes,Suspended"
      response.body.should contain "Id [Team],Created at [Team],Updated at [Team],Name [Team],Logo url [Team],Team Manager [Team],Ballpark [Team],Mascot [Team],Founded [Team],Wins [Team],Losses [Team],Win percentage [Team],Revenue [Team],Color [Team]"
      response.body.should contain "Id [Draft],Created at [Draft],Updated at [Draft],Date [Draft],Round [Draft],Pick [Draft],Overall [Draft],College [Draft],Notes [Draft]"
      response.body.should contain "Id [Comments],Content [Comments],Created at [Comments],Updated at [Comments]"
      response.body.should contain @player.name
      response.body.should contain @player.team.name
      response.body.should contain @player.draft.college
      response.body.should contain @player.comments.first.content.split("\n").first.strip # can't match for more than one line
      response.body.should contain @player.comments.second.content.split("\n").first.strip
    end
    
    it "should allow to export to JSON" do
      post rails_admin_export_path(:model_name => 'player')
      click_button 'Export to json'
      response.should be_successful
      response.body.should contain @player.team.name
    end

    it "should allow to export to XML" do
      post rails_admin_export_path(:model_name => 'player')
      click_button 'Export to xml'
      response.should be_successful
      response.body.should contain @player.team.name
    end

    it "should export polymorphic fields the easy way for now" do
      post rails_admin_export_path(:model_name => 'comment')
      select "<comma> ','", :from => "csv_options_generator_col_sep"
      click_button 'Export to csv'
      response.body.should contain "Id,Commentable,Commentable type,Content,Created at,Updated at"
      response.body.should contain "#{@player.comments.first.id},#{@player.id},#{@player.class}"
    end
  end
  
  describe "POST /admin/players/export :format => :csv" do
    it "should export with modified schema" do
      post rails_admin_export_path(:model_name => 'player', :schema => @non_default_schema, :csv => true, :all => true, :csv_options => { :generator => { :col_sep => "," } })
      response.body.should contain "Id,Updated at,Deleted at,Name,Position,Number,Retired,Injured,Born on,Notes,Suspended" # no created_at
    end
  end
end