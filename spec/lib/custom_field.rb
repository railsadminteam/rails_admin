require 'spec_helper'

describe "RailsAdmin external custom field" do
  it "should be there" do
    RailsAdmin.config(Team).fields.map(&:type).should include(:custom_field)
  end
end