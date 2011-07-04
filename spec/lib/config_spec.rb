require 'spec_helper'

describe RailsAdmin::Config do

  describe "ActiveRecord::Base.rails_admin" do

    let(:config) { lambda {} }

    it "should proxy to RailsAdmin::Config.model" do
      RailsAdmin::Config.should_receive(:model) do |*args, &block|
        args[0].should eql(Team)
        block.should eql(config)
      end
      Team.rails_admin(&config)
    end
  end
end
