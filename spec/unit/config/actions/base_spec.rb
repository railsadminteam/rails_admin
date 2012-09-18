require 'spec_helper'

describe RailsAdmin::Config::Actions::Base do

  describe "#visible?" do
    it 'should exclude models not referenced in the only array' do
      RailsAdmin.config do |config|
        config.actions do
          index do
            only [Player, Cms::BasicPage]
          end
        end
      end
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Player)}).should be_visible
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)}).should be_nil
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Cms::BasicPage)}).should be_visible
    end
    
    it 'should exclude models referenced in the except array' do
      RailsAdmin.config do |config|
        config.actions do
          index do
            except [Player, Cms::BasicPage]
          end
        end
      end
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Player)}).should be_nil
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)}).should be_visible
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Cms::BasicPage)}).should be_nil
    end
  end
end
