require 'spec_helper'

describe RailsAdmin::Config::Actions::Base do

  describe "visible?" do
    it 'should exclude fields not referenced in the only array' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard do
            only Player
          end
        end
      end
      RailsAdmin::Config::Actions.find(:dashboard, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Player)}).visible?.should_be true
      RailsAdmin::Config::Actions.find(:dashboard, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)}).visible?.should_be false
    end
  end
end
