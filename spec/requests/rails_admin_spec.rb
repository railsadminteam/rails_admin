require 'spec_helper'

describe "RailsAdmin" do

  describe "authentication" do
    it "should be disableable" do
      logout
      RailsAdmin.authenticate_with {}
      get rails_admin_dashboard_path
      response.should be_successful
    end
  end

end
