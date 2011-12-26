require 'spec_helper'

describe "RailsAdmin" do
  describe ".associated_collection_cache_all" do
    it "should default to true if associated collection count < 100" do
      RailsAdmin.config(Team).edit.fields.find{|f| f.name == :players}.associated_collection_cache_all.should == true
    end

    it "should default to false if associated collection count >= 100" do
      @players = 100.times.map do
        FactoryGirl.create :player
      end
      RailsAdmin.config(Team).edit.fields.find{|f| f.name == :players}.associated_collection_cache_all.should == false
    end
  end

  describe ".add_extension" do
    it "registers the extension with RailsAdmin" do
      RailsAdmin.add_extension(:example, ExampleModule)
      RailsAdmin::EXTENSIONS.select { |name| name == :example }.length.should == 1
    end

    context "given an extension with an authorization adapter" do
      it "registers the adapter" do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :authorization => true
        })
        RailsAdmin::AUTHORIZATION_ADAPTERS[:example].should == ExampleModule::AuthorizationAdapter
      end
    end

    context "given an extension with a configuration adapter" do
      it "registers the adapter" do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :configuration => true
        })
        RailsAdmin::CONFIGURATION_ADAPTERS[:example].should == ExampleModule::ConfigurationAdapter
      end
    end
  end

  describe ".attr_accessible_role" do
    it "sould be :default by default" do
      RailsAdmin.config.attr_accessible_role.call.should == :default
    end

    it "sould be configurable with user role for example" do
      RailsAdmin.config do |config|
        config.attr_accessible_role do
          :admin
        end
      end

      RailsAdmin.config.attr_accessible_role.call.should == :admin
    end
  end

  describe ".main_app_name" do

    it "as a default meaningful dynamic value" do
      RailsAdmin.config.main_app_name.call.should == ['Dummy App', 'Admin']
    end

    it "can be configured" do
      RailsAdmin.config do |config|
        config.main_app_name = ['static','value']
      end
      RailsAdmin.config.main_app_name.should == ['static','value']
    end
  end

  describe ".authorize_with" do
    context "given a key for a extension with authorization" do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :authorization => true
        })
      end

      it "initializes the authorization adapter" do
        ExampleModule::AuthorizationAdapter.should_receive(:new).with(RailsAdmin::Config)
        RailsAdmin.config do |config|
          config.authorize_with(:example)
        end
        RailsAdmin.config.authorize_with.call
      end

      it "passes through any additional arguments to the initializer" do
        options = { :option => true }
        ExampleModule::AuthorizationAdapter.should_receive(:new).with(RailsAdmin::Config, options)
        RailsAdmin.config do |config|
          config.authorize_with(:example, options)
        end
        RailsAdmin.config.authorize_with.call
      end
    end
  end

  describe ".configure_with" do
    context "given a key for a extension with configuration" do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :configuration => true
        })
      end

      it "initializes configuration adapter" do
        ExampleModule::ConfigurationAdapter.should_receive(:new)
        RailsAdmin.config do |config|
          config.configure_with(:example)
        end
      end

      it "yields the (optionally) provided block, passing the initialized adapter" do
        configurator = nil
        RailsAdmin.config do |config|
          config.configure_with(:example) do |configuration_adapter|
            configurator = configuration_adapter
          end
        end
        configurator.should be_a(ExampleModule::ConfigurationAdapter)
      end
    end
  end

  describe ".config" do
    context ".default_search_operator" do
      it "sets the default_search_operator" do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'
        end
        RailsAdmin::Config.default_search_operator.should == 'starts_with'
      end

      it "errors on unrecognized search operator" do
        expect do
          RailsAdmin.config do |config|
            config.default_search_operator = 'random'
          end
        end.to raise_error(ArgumentError, "Search operator 'random' not supported")
      end

      it "defaults to 'default'" do
        RailsAdmin::Config.default_search_operator.should == 'default'
      end
    end
  end
  
  
  describe "DSL field inheritance" do
    it 'should be tested' do
      RailsAdmin.config do |config|
        config.model Fan do
          field :name do
            label do
              @label ||= "modified base #{label}"
            end
          end
          list do 
            field :name do
              label do
                @label ||= "modified list #{label}"
              end
            end
          end
          edit do 
            field :name do
              label do
                @label ||= "modified edit #{label}"
              end
            end
          end
          create do 
            field :name do
              label do
                @label ||= "modified create #{label}"
              end
            end
          end
        end
        
      end
      RailsAdmin.config(Fan).visible_fields.count.should == 1
      RailsAdmin.config(Fan).visible_fields.first.label.should == 'modified base His Name'
      RailsAdmin.config(Fan).list.visible_fields.first.label.should == 'modified list His Name'
      RailsAdmin.config(Fan).export.visible_fields.first.label.should == 'modified base His Name'
      RailsAdmin.config(Fan).edit.visible_fields.first.label.should == 'modified edit His Name'
      RailsAdmin.config(Fan).create.visible_fields.first.label.should == 'modified create His Name'
      RailsAdmin.config(Fan).update.visible_fields.first.label.should == 'modified edit His Name'
    end
  end
  
  describe "DSL group inheritance" do
    it 'should be tested' do
      RailsAdmin.config do |config|
        config.model Team do
          list do
            group "a" do
              field :founded
            end
            
            group "b" do
              field :name
              field :wins
            end
          end
          
          edit do
            group "a" do
              field :name
            end
            
            group "c" do
              field :founded
              field :wins
            end
          end
          
          update do
            group "d" do
              field :wins
            end
            
            group "e" do
              field :losses
            end
          end
        end
      end
      
      RailsAdmin.config(Team).list.visible_groups.map{|g| g.visible_fields.map(&:name) }.should == [[:founded], [:name, :wins]]
      RailsAdmin.config(Team).edit.visible_groups.map{|g| g.visible_fields.map(&:name) }.should == [[:name], [:founded, :wins]]
      RailsAdmin.config(Team).create.visible_groups.map{|g| g.visible_fields.map(&:name) }.should == [[:name], [:founded, :wins]]
      RailsAdmin.config(Team).update.visible_groups.map{|g| g.visible_fields.map(&:name) }.should == [[:name], [:founded], [:wins], [:losses]]
      RailsAdmin.config(Team).visible_groups.map{|g| g.visible_fields.map(&:name) }.flatten.count.should == 18
      RailsAdmin.config(Team).export.visible_groups.map{|g| g.visible_fields.map(&:name) }.flatten.count.should == 18
    end
  end
end

module ExampleModule
  class AuthorizationAdapter ; end
  class ConfigurationAdapter ; end
end
