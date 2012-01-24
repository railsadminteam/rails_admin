require 'spec_helper'

describe RailsAdmin::ApplicationHelper do
  
  describe '#current_action?' do
    it 'should return true if current_action, false otherwise' do
      @action = RailsAdmin::Config::Actions.find(:index)
      
      helper.current_action?(RailsAdmin::Config::Actions.find(:index)).should be_true
      helper.current_action?(RailsAdmin::Config::Actions.find(:show)).should_not be_true
    end
  end
  
  describe '#action' do
    it 'should return action by :custom_key' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard do
            custom_key :my_custom_dashboard_key
          end
        end
      end
      
      helper.action(:my_custom_dashboard_key).should == RailsAdmin::Config::Actions.find(:my_custom_dashboard_key)
    end
    
    it 'should return only visible actions' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard do
            visible false
          end
        end
      end
      
      helper.action(:dashboard).should == nil
    end
    
    it 'should return only visible actions, passing all bindings' do
      RailsAdmin.config do |config|
        config.actions do
          member :test_bindings do
            visible do
              bindings[:controller].is_a?(ActionView::TestCase::TestController) and
              bindings[:abstract_model].model == Team and
              bindings[:object].is_a? Team
            end
          end
        end
      end
      
      helper.action(:test_bindings, RailsAdmin::AbstractModel.new(Team), Team.new).should == RailsAdmin::Config::Actions.find(:test_bindings)
      helper.action(:test_bindings, RailsAdmin::AbstractModel.new(Team), Player.new).should == nil
      helper.action(:test_bindings, RailsAdmin::AbstractModel.new(Player), Team.new).should == nil
    end
  end
  
  describe "#actions" do
    it 'should return actions by type' do
      abstract_model = RailsAdmin::AbstractModel.new(Player)
      object = FactoryGirl.create :player
      helper.actions(:all, abstract_model, object).map(&:custom_key).should == [:dashboard, :index, :show, :new, :edit, :export, :delete, :bulk_delete, :history_show, :history_index, :show_in_app]
      helper.actions(:root, abstract_model, object).map(&:custom_key).should == [:dashboard]
      helper.actions(:collection, abstract_model, object).map(&:custom_key).should == [:index, :new, :export, :bulk_delete, :history_index]
      helper.actions(:member, abstract_model, object).map(&:custom_key).should == [:show, :edit, :delete, :history_show, :show_in_app]
    end
    
    it 'should only return visible actions, passing bindings correctly' do
      RailsAdmin.config do |config|
        config.actions do
          member :test_bindings do
            visible do
              bindings[:controller].is_a?(ActionView::TestCase::TestController) and
              bindings[:abstract_model].model == Team and
              bindings[:object].is_a? Team
            end
          end
        end
      end
      
      helper.actions(:all, RailsAdmin::AbstractModel.new(Team), Team.new).map(&:custom_key).should == [:test_bindings]
      helper.actions(:all, RailsAdmin::AbstractModel.new(Team), Player.new).map(&:custom_key).should == []
      helper.actions(:all, RailsAdmin::AbstractModel.new(Player), Team.new).map(&:custom_key).should == []
    end
  end
  
  describe "#wording_for" do
    it "gives correct wording even if action is not visible" do
      RailsAdmin.config do |config|
        config.actions do
          index do
            visible false
          end
        end
      end
      
      helper.wording_for(:menu, :index).should == "List"
    end
    
    it "passes correct bindings" do
      helper.wording_for(:title, :edit, RailsAdmin::AbstractModel.new(Team), Team.new(:name => 'the avengers')).should == "Edit Team 'the avengers'"
    end
    
    it "defaults correct bindings" do
      @action = RailsAdmin::Config::Actions.find :edit
      @abstract_model = RailsAdmin::AbstractModel.new(Team)
      @object = Team.new(:name => 'the avengers')
      helper.wording_for(:title).should == "Edit Team 'the avengers'"
    end
    
    it "does not try to use the wrong :label_metod" do
      @abstract_model = RailsAdmin::AbstractModel.new(Draft)
      @object = Draft.new
      
      helper.wording_for(:link, :new, RailsAdmin::AbstractModel.new(Team)).should == "Add a new Team"
    end
    
  end
  
  describe "#breadcrumb" do
    it "gives us a breadcrumb, dammit" do
      @action = RailsAdmin::Config::Actions.find :edit
      @abstract_model = RailsAdmin::AbstractModel.new(Team)
      @object = Team.new(:name => 'the avengers')
      bc = helper.breadcrumb
      bc.should match /Dashboard/ # dashboard
      bc.should match /Teams/ # list
      bc.should match /the avengers/  # show
      bc.should match /Edit/ # current (edit)
    end
  end
  
  describe "#menu_for" do
    it 'passes model and object as bindings and generates a menu, excluding non-get actions' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard
          index do
            visible do
              bindings[:abstract_model].model == Team
            end
          end
          show do
            visible do
              bindings[:object].class == Team
            end
          end
          delete do
            http_methods [:post, :put, :delete]
          end
        end
      end
      
      @action = RailsAdmin::Config::Actions.find :show
      @abstract_model = RailsAdmin::AbstractModel.new(Team)
      @object = Team.new(:name => 'the avengers')

      helper.menu_for(:root).should match /Dashboard/
      helper.menu_for(:collection, @abstract_model).should match /List/
      helper.menu_for(:member, @abstract_model, @object).should match /Show/
      
      @abstract_model = RailsAdmin::AbstractModel.new(Player)
      @object = Player.new
      helper.menu_for(:collection, @abstract_model).should_not match /List/
      helper.menu_for(:member, @abstract_model, @object).should_not match /Show/
    end
    
    it "excludes non-get actions" do
      RailsAdmin.config do |config|
        config.actions do
          dashboard do
            http_methods [:post, :put, :delete]
          end
        end
      end
      
      @action = RailsAdmin::Config::Actions.find :dashboard
      helper.menu_for(:root).should_not match /Dashboard/
    end
  end
  
  describe "#bulk_menu" do
    it 'should include all visible bulkable actions' do
      RailsAdmin.config do |config|
        config.actions do
          index
          collection :zorg do
            bulkable true
            action_name :zorg_action
          end
          collection :blub do
            bulkable true
            visible do
              bindings[:abstract_model].model == Team
            end
          end
        end
      end
      @action = RailsAdmin::Config::Actions.find :index
      
      result = helper.bulk_menu(RailsAdmin::AbstractModel.new(Team))
      result.should match "zorg_action"
      result.should match "blub"

      helper.bulk_menu(RailsAdmin::AbstractModel.new(Player)).should_not match "blub"
    end
  end
end