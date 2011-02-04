if ENV["AUTHORIZATION_ADAPTER"] == "cancan"
  require 'spec_helper'

  class Ability
    include CanCan::Ability
    def initialize(user)
      can :manage, :all
    end
  end

  describe "RailsAdmin CanCan Authorization" do
    before(:each) do
      RailsAdmin::Config.authorization_adapter = :cancan
    end

    describe "GET /admin" do
      before(:each) do
        get rails_admin_dashboard_path
      end

      it "should respond successfully" do
        response.code.should == "200"
      end

    end

  end

end
