require 'spec_helper'

describe RailsAdmin::Config::Actions::Base do

  describe "visible?" do
    it 'should exclude models not referenced in the only array' do
      RailsAdmin.config do |config|
        config.actions do
          index do
            only [Player, Comment]
          end
        end
      end
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Player)}).visible?.should be_true
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)}).should be_nil
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Comment)}).visible?.should be_true
    end
    
    it 'should exclude models referenced in the except array' do
      RailsAdmin.config do |config|
        config.actions do
          index do
            except [Player, Comment]
          end
        end
      end
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Player)}).should be_nil
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)}).visible?.should be_true
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Comment)}).should be_nil
    end
  end
end
