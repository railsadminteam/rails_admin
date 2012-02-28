require 'spec_helper'

describe RailsAdmin::Config::Actions do

  describe "default" do
    it 'should be as before' do
      RailsAdmin::Config::Actions.all.map(&:key).should == [:dashboard, :index, :show, :new, :edit, :export, :delete, :bulk_delete, :history_show, :history_index, :show_in_app]
    end
  end

  describe 'find' do
    it 'should find by custom key' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard do
            custom_key :custom_dashboard
          end

          collection :custom_collection, :index

          show
        end
      end

      RailsAdmin::Config::Actions.find(:custom_dashboard).should be_a(RailsAdmin::Config::Actions::Dashboard)
      RailsAdmin::Config::Actions.find(:custom_collection).should be_a(RailsAdmin::Config::Actions::Index)
      RailsAdmin::Config::Actions.find(:show).should be_a(RailsAdmin::Config::Actions::Show)
    end

    it 'should return nil when no action is found by the custom key' do
      RailsAdmin::Config::Actions.find(:non_existent_action_key).should be_nil
    end

    it 'should return visible action passing binding if controller binding is given, and pass action visible or not if no' do
      RailsAdmin.config do |config|
        config.actions do
          root :custom_root do
            visible do
              bindings[:controller] == "controller"
            end
          end
        end
      end
      RailsAdmin::Config::Actions.find(:custom_root).should be_a(RailsAdmin::Config::Actions::Base)
      RailsAdmin::Config::Actions.find(:custom_root, {:controller => "not_controller"}).should be_nil
      RailsAdmin::Config::Actions.find(:custom_root, {:controller => "controller"}).should be_a(RailsAdmin::Config::Actions::Base)
    end

    it 'should check bindings[:abstract_model] visibility while checking action\'s visibility' do
      RailsAdmin.config Team do
        hide
      end

      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Comment)}).should be_a(RailsAdmin::Config::Actions::Index) #decoy
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)}).should be_nil
    end

    it 'should check bindings[:abstract_model] presence while checking action\'s visibility' do
      RailsAdmin.config do |config|
        config.excluded_models << Team
      end
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Comment)}).should be_a(RailsAdmin::Config::Actions::Index) #decoy
      RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)}).should be_nil
    end
  end

  describe 'all' do
    it 'should return all defined actions' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard
          index
        end
      end

      RailsAdmin::Config::Actions.all.map(&:key).should == [:dashboard, :index]
    end

    it 'should restrict by scope' do
      RailsAdmin.config do |config|
        config.actions do
          root :custom_root
          collection :custom_collection
          member :custom_member
        end
      end
      RailsAdmin::Config::Actions.all(:root).map(&:key).should == [:custom_root]
      RailsAdmin::Config::Actions.all(:collection).map(&:key).should == [:custom_collection]
      RailsAdmin::Config::Actions.all(:member).map(&:key).should == [:custom_member]
    end

    it 'should return all visible actions passing binding if controller binding is given, and pass all actions if no' do
      RailsAdmin.config do |config|
        config.actions do
          root :custom_root do
            visible do
              bindings[:controller] == "controller"
            end
          end
        end
      end
      RailsAdmin::Config::Actions.all(:root).map(&:custom_key).should == [:custom_root]
      RailsAdmin::Config::Actions.all(:root, {:controller => "not_controller"}).map(&:custom_key).should == []
      RailsAdmin::Config::Actions.all(:root, {:controller => "controller"}).map(&:custom_key).should == [:custom_root]
    end
  end

  describe "customized through DSL" do
    it 'should add the one asked' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard
          index
          show
        end
      end

      RailsAdmin::Config::Actions.all.map(&:key).should == [:dashboard, :index, :show]
    end

    it 'should allow to customize the custom_key when customizing an existing action' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard do
            custom_key :my_dashboard
          end
        end
      end
      RailsAdmin::Config::Actions.all.map(&:custom_key).should == [:my_dashboard]
      RailsAdmin::Config::Actions.all.map(&:key).should == [:dashboard]
    end

    it 'should allow to change the key and the custom_key when "subclassing" an existing action' do
      RailsAdmin.config do |config|
        config.actions do
          root :my_dashboard_key, :dashboard do
            custom_key :my_dashboard_custom_key
          end
        end
      end
      RailsAdmin::Config::Actions.all.map(&:custom_key).should == [:my_dashboard_custom_key]
      RailsAdmin::Config::Actions.all.map(&:key).should == [:my_dashboard_key]
      RailsAdmin::Config::Actions.all.map(&:class).should == [RailsAdmin::Config::Actions::Dashboard]
    end

    it 'should not add the same custom_key twice' do
      lambda do
        RailsAdmin.config do |config|
          config.actions do
            dashboard
            dashboard
          end
        end
      end.should raise_error("Action dashboard already exist. Please change its custom key")


      lambda do
        RailsAdmin.config do |config|
          config.actions do
            index
            collection :index
          end
        end
      end.should raise_error("Action index already exist. Please change its custom key")
    end

    it 'should add the same key with different custom key' do
      RailsAdmin.config do |config|
        config.actions do
          dashboard
          dashboard do
            custom_key :my_dashboard
          end
        end
      end

      RailsAdmin::Config::Actions.all.map(&:custom_key).should == [:dashboard, :my_dashboard]
      RailsAdmin::Config::Actions.all.map(&:key).should == [:dashboard, :dashboard]
    end
  end
end
