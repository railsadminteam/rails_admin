require 'spec_helper'

describe RailsAdmin::Config::Actions do

  describe "default" do
    it "should be as before" do
      expect(RailsAdmin::Config::Actions.all.map(&:key)).to eq([:dashboard, :index, :show, :new, :edit, :export, :delete, :bulk_delete, :history_show, :history_index, :show_in_app])
    end
  end

  describe "find" do
    it "should find by custom key" do
      RailsAdmin.config do |config|
        config.actions do
          dashboard do
            custom_key :custom_dashboard
          end

          collection :custom_collection, :index

          show
        end
      end

      expect(RailsAdmin::Config::Actions.find(:custom_dashboard)).to be_a(RailsAdmin::Config::Actions::Dashboard)
      expect(RailsAdmin::Config::Actions.find(:custom_collection)).to be_a(RailsAdmin::Config::Actions::Index)
      expect(RailsAdmin::Config::Actions.find(:show)).to be_a(RailsAdmin::Config::Actions::Show)
    end

    it "should return nil when no action is found by the custom key" do
      expect(RailsAdmin::Config::Actions.find(:non_existent_action_key)).to be_nil
    end

    it "should return visible action passing binding if controller binding is given, and pass action visible or not if no" do
      RailsAdmin.config do |config|
        config.actions do
          root :custom_root do
            visible do
              bindings[:controller] == "controller"
            end
          end
        end
      end
      expect(RailsAdmin::Config::Actions.find(:custom_root)).to be_a(RailsAdmin::Config::Actions::Base)
      expect(RailsAdmin::Config::Actions.find(:custom_root, {:controller => "not_controller"})).to be_nil
      expect(RailsAdmin::Config::Actions.find(:custom_root, {:controller => "controller"})).to be_a(RailsAdmin::Config::Actions::Base)
    end

    it "should check bindings[:abstract_model] visibility while checking action\'s visibility" do
      RailsAdmin.config Team do
        hide
      end

      expect(RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Comment)})).to be_a(RailsAdmin::Config::Actions::Index) #decoy
      expect(RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)})).to be_nil
    end

    it "should check bindings[:abstract_model] presence while checking action\'s visibility" do
      RailsAdmin.config do |config|
        config.excluded_models << Team
      end
      expect(RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Comment)})).to be_a(RailsAdmin::Config::Actions::Index) #decoy
      expect(RailsAdmin::Config::Actions.find(:index, {:controller => double(:authorized? => true), :abstract_model => RailsAdmin::AbstractModel.new(Team)})).to be_nil
    end
  end

  describe "all" do
    it "should return all defined actions" do
      RailsAdmin.config do |config|
        config.actions do
          dashboard
          index
        end
      end

      expect(RailsAdmin::Config::Actions.all.map(&:key)).to eq([:dashboard, :index])
    end

    it "should restrict by scope" do
      RailsAdmin.config do |config|
        config.actions do
          root :custom_root
          collection :custom_collection
          member :custom_member
        end
      end
      expect(RailsAdmin::Config::Actions.all(:root).map(&:key)).to eq([:custom_root])
      expect(RailsAdmin::Config::Actions.all(:collection).map(&:key)).to eq([:custom_collection])
      expect(RailsAdmin::Config::Actions.all(:member).map(&:key)).to eq([:custom_member])
    end

    it "should return all visible actions passing binding if controller binding is given, and pass all actions if no" do
      RailsAdmin.config do |config|
        config.actions do
          root :custom_root do
            visible do
              bindings[:controller] == "controller"
            end
          end
        end
      end
      expect(RailsAdmin::Config::Actions.all(:root).map(&:custom_key)).to eq([:custom_root])
      expect(RailsAdmin::Config::Actions.all(:root, {:controller => "not_controller"}).map(&:custom_key)).to eq([])
      expect(RailsAdmin::Config::Actions.all(:root, {:controller => "controller"}).map(&:custom_key)).to eq([:custom_root])
    end
  end

  describe "customized through DSL" do
    it "should add the one asked" do
      RailsAdmin.config do |config|
        config.actions do
          dashboard
          index
          show
        end
      end

      expect(RailsAdmin::Config::Actions.all.map(&:key)).to eq([:dashboard, :index, :show])
    end

    it "should allow to customize the custom_key when customizing an existing action" do
      RailsAdmin.config do |config|
        config.actions do
          dashboard do
            custom_key :my_dashboard
          end
        end
      end
      expect(RailsAdmin::Config::Actions.all.map(&:custom_key)).to eq([:my_dashboard])
      expect(RailsAdmin::Config::Actions.all.map(&:key)).to eq([:dashboard])
    end

    it "should allow to change the key and the custom_key when subclassing an existing action" do
      RailsAdmin.config do |config|
        config.actions do
          root :my_dashboard_key, :dashboard do
            custom_key :my_dashboard_custom_key
          end
        end
      end
      expect(RailsAdmin::Config::Actions.all.map(&:custom_key)).to eq([:my_dashboard_custom_key])
      expect(RailsAdmin::Config::Actions.all.map(&:key)).to eq([:my_dashboard_key])
      expect(RailsAdmin::Config::Actions.all.map(&:class)).to eq([RailsAdmin::Config::Actions::Dashboard])
    end

    it "should not add the same custom_key twice" do
      expect do
        RailsAdmin.config do |config|
          config.actions do
            dashboard
            dashboard
          end
        end
      end.to raise_error("Action dashboard already exist. Please change its custom key")

      expect do
        RailsAdmin.config do |config|
          config.actions do
            index
            collection :index
          end
        end
      end.to raise_error("Action index already exist. Please change its custom key")
    end

    it "should add the same key with different custom key" do
      RailsAdmin.config do |config|
        config.actions do
          dashboard
          dashboard do
            custom_key :my_dashboard
          end
        end
      end

      expect(RailsAdmin::Config::Actions.all.map(&:custom_key)).to eq([:dashboard, :my_dashboard])
      expect(RailsAdmin::Config::Actions.all.map(&:key)).to eq([:dashboard, :dashboard])
    end
  end
end
