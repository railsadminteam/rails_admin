require 'spec_helper'

describe RailsAdmin::MainController do
  describe "get_collection" do
    it "works" do
      RailsAdmin.config do |config|
        #
      end
      controller.params = {}
      controller.get_collection(RailsAdmin.config(Team), RailsAdmin.config(Team).abstract_model.scoped).to_sql.should == 'SELECT  "teams".* FROM "teams"  ORDER BY teams.id desc LIMIT 20 OFFSET 0'
      controller.params = { :query => "test" }
      controller.get_collection(RailsAdmin.config(Team), RailsAdmin.config(Team).abstract_model.scoped).to_sql.should == "SELECT  \"teams\".* FROM \"teams\"  WHERE (((teams.name LIKE '%test%') OR (teams.logo_url LIKE '%test%') OR (teams.manager LIKE '%test%') OR (teams.ballpark LIKE '%test%') OR (teams.mascot LIKE '%test%') OR (teams.color IN ('test')) OR (divisions.name LIKE '%test%'))) ORDER BY teams.id desc LIMIT 20 OFFSET 0"
    end
  end
end
