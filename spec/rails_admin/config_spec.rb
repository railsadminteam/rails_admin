require 'spec_helper'

describe RailsAdmin::Config do

  describe ".included_models" do

    it "only uses included models" do
      RailsAdmin.config.included_models = [Team, League]
      expect(RailsAdmin::AbstractModel.all.map(&:model)).to eq([League, Team]) # it gets sorted
    end

    it "does not restrict models if included_models is left empty" do
      RailsAdmin.config.included_models = []
      expect(RailsAdmin::AbstractModel.all.map(&:model)).to include(Team, League)
    end

    it "removes excluded models (whitelist - blacklist)" do
      RailsAdmin.config.excluded_models = [Team]
      RailsAdmin.config.included_models = [Team, League]
      expect(RailsAdmin::AbstractModel.all.map(&:model)).to eq([League])
    end

    it "always excludes history", :active_record => true do
      expect(RailsAdmin::AbstractModel.all.map(&:model)).not_to include(RailsAdmin::History)
    end

    it "excluded? returns true for any model not on the list" do
      RailsAdmin.config.included_models = [Team, League]

      team_config = RailsAdmin::AbstractModel.new('Team').config
      fan_config = RailsAdmin::AbstractModel.new('Fan').config

      expect(fan_config).to be_excluded
      expect(team_config).not_to be_excluded
    end
  end

  describe ".add_extension" do
    before do
      silence_warnings do
        RailsAdmin::EXTENSIONS = []
      end
    end

    it "registers the extension with RailsAdmin" do
      RailsAdmin.add_extension(:example, ExampleModule)
      expect(RailsAdmin::EXTENSIONS.select { |name| name == :example }.length).to eq(1)
    end

    context "given an extension with an authorization adapter" do
      it "registers the adapter" do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :authorization => true
        })
        expect(RailsAdmin::AUTHORIZATION_ADAPTERS[:example]).to eq(ExampleModule::AuthorizationAdapter)
      end
    end

    context "given an extension with an auditing adapter" do
      it "registers the adapter" do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :auditing => true
        })
        expect(RailsAdmin::AUDITING_ADAPTERS[:example]).to eq(ExampleModule::AuditingAdapter)
      end
    end

    context "given an extension with a configuration adapter" do
      it "registers the adapter" do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :configuration => true
        })
        expect(RailsAdmin::CONFIGURATION_ADAPTERS[:example]).to eq(ExampleModule::ConfigurationAdapter)
      end
    end
  end

  describe ".attr_accessible_role" do
    it "sould be :default by default" do
      expect(RailsAdmin.config.attr_accessible_role.call).to eq(:default)
    end

    it "sould be configurable with user role for example" do
      RailsAdmin.config do |config|
        config.attr_accessible_role do
          :admin
        end
      end

      expect(RailsAdmin.config.attr_accessible_role.call).to eq(:admin)
    end
  end

  describe ".main_app_name" do

    it "as a default meaningful dynamic value" do
      expect(RailsAdmin.config.main_app_name.call).to eq(['Dummy App', 'Admin'])
    end

    it "can be configured" do
      RailsAdmin.config do |config|
        config.main_app_name = ['static','value']
      end
      expect(RailsAdmin.config.main_app_name).to eq(['static','value'])
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

  describe ".audit_with" do
    context "given a key for a extension with auditing" do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :auditing => true
        })
      end

      it "initializes the auditing adapter" do
        ExampleModule::AuditingAdapter.should_receive(:new).with(RailsAdmin::Config)
        RailsAdmin.config do |config|
          config.audit_with(:example)
        end
        RailsAdmin.config.audit_with.call
      end

      it "passes through any additional arguments to the initializer" do
        options = { :option => true }
        ExampleModule::AuditingAdapter.should_receive(:new).with(RailsAdmin::Config, options)
        RailsAdmin.config do |config|
          config.audit_with(:example, options)
        end
        RailsAdmin.config.audit_with.call
      end
    end

    context "given paper_trail as the extension for auditing" do
      before do
        RailsAdmin.add_extension(:example, RailsAdmin::Extensions::PaperTrail, {
          :auditing => true
        })
      end

      it "initializes the auditing adapter" do
        RailsAdmin.config do |config|
          config.audit_with(:example)
        end
        expect(RailsAdmin.config.audit_with.call).not_to raise_exception ArgumentError
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
        expect(configurator).to be_a(ExampleModule::ConfigurationAdapter)
      end
    end
  end

  describe ".config" do
    context ".default_search_operator" do
      it "sets the default_search_operator" do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'
        end
        expect(RailsAdmin::Config.default_search_operator).to eq('starts_with')
      end

      it "errors on unrecognized search operator" do
        expect do
          RailsAdmin.config do |config|
            config.default_search_operator = 'random'
          end
        end.to raise_error(ArgumentError, "Search operator 'random' not supported")
      end

      it "defaults to 'default'" do
        expect(RailsAdmin::Config.default_search_operator).to eq('default')
      end
    end
  end

  describe ".visible_models" do
    it "passes controller bindings, find visible models, order them" do
      RailsAdmin.config do |config|
        config.included_models = [Player, Fan, Comment, Team]

        config.model Player do
          hide
        end
        config.model Fan do
          weight -1
          show
        end
        config.model Comment do
          visible do
            bindings[:controller]._current_user.role == :admin
          end
        end
        config.model Team do
          visible do
            bindings[:controller]._current_user.role != :admin
          end
        end
      end

      expect(RailsAdmin.config.visible_models(:controller => double(:_current_user => double(:role => :admin), :authorized? => true)).map(&:abstract_model).map(&:model)).to match_array [Fan, Comment]
    end

    it "hides unallowed models" do
      RailsAdmin.config do |config|
        config.included_models = [Comment]
      end
      expect(RailsAdmin.config.visible_models(:controller => double(:authorized? => true)).map(&:abstract_model).map(&:model)).to eq([Comment])
      expect(RailsAdmin.config.visible_models(:controller => double(:authorized? => false)).map(&:abstract_model).map(&:model)).to eq([])
    end

    it "does not contain embedded model", :mongoid => true do
      RailsAdmin.config do |config|
        config.included_models = [FieldTest, Comment, Embed]
      end

      expect(RailsAdmin.config.visible_models(:controller => double(:_current_user => double(:role => :admin), :authorized? => true)).map(&:abstract_model).map(&:model)).to match_array [FieldTest, Comment]
     end

    it "basically does not contain embedded model except model using recursively_embeds_many or recursively_embeds_one", :mongoid => true do
      class RecursivelyEmbedsOne
        include Mongoid::Document
        recursively_embeds_one
      end
      class RecursivelyEmbedsMany
        include Mongoid::Document
        recursively_embeds_many
      end
      RailsAdmin.config do |config|
        config.included_models = [FieldTest, Comment, Embed, RecursivelyEmbedsMany, RecursivelyEmbedsOne]
      end
      expect(RailsAdmin.config.visible_models(:controller => double(:_current_user => double(:role => :admin), :authorized? => true)).map(&:abstract_model).map(&:model)).to match_array [FieldTest, Comment, RecursivelyEmbedsMany, RecursivelyEmbedsOne]
    end
  end
end

module ExampleModule
  class AuthorizationAdapter ; end
  class ConfigurationAdapter ; end
  class AuditingAdapter ; end
end
