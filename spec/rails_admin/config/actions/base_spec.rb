

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Actions::Base do
  describe '#enabled?' do
    it 'excludes models not referenced in the only array' do
      RailsAdmin.config do |config|
        config.actions do
          index do
            only [Player, Cms::BasicPage]
          end
        end
      end
      expect(RailsAdmin::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(Player))).to be_enabled
      expect(RailsAdmin::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(Team))).to be_nil
      expect(RailsAdmin::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(Cms::BasicPage))).to be_enabled
    end

    it 'excludes models referenced in the except array' do
      RailsAdmin.config do |config|
        config.actions do
          index do
            except [Player, Cms::BasicPage]
          end
        end
      end
      expect(RailsAdmin::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(Player))).to be_nil
      expect(RailsAdmin::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(Team))).to be_enabled
      expect(RailsAdmin::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(Cms::BasicPage))).to be_nil
    end

    it 'is always true for a writable model' do
      RailsAdmin.config do |config|
        config.actions do
          index
          show
          new
          edit
          delete
        end
      end
      %i[index show new edit delete].each do |action|
        expect(RailsAdmin::Config::Actions.find(action, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(Player), object: Player.new)).to be_enabled
      end
    end

    it 'is false for write operations of a read-only model' do
      RailsAdmin.config do |config|
        config.actions do
          index
          show
          new
          edit
          delete
        end
      end
      expect(RailsAdmin::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(ReadOnlyComment))).to be_enabled
      expect(RailsAdmin::Config::Actions.find(:show, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(ReadOnlyComment), object: ReadOnlyComment.new)).to be_enabled
      expect(RailsAdmin::Config::Actions.find(:new, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(ReadOnlyComment))).to be_enabled
      expect(RailsAdmin::Config::Actions.find(:edit, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(ReadOnlyComment), object: ReadOnlyComment.new)).to be_nil
      expect(RailsAdmin::Config::Actions.find(:delete, controller: double(authorized?: true), abstract_model: RailsAdmin::AbstractModel.new(ReadOnlyComment), object: ReadOnlyComment.new)).to be_nil
    end
  end
end
