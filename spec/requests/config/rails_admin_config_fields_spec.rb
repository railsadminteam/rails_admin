require 'spec_helper'

describe "RailsAdmin Config Fields" do
  describe "binary field" do

    it "should be displayed as checkbox input" do
      get rails_admin_new_path(:model_name => "league")
      response.should have_tag('input[type=checkbox]#league_amateur')
    end

  end
end
