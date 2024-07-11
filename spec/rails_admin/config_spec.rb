

require 'spec_helper'

RSpec.describe RailsAdmin::Config do
  describe '.included_models' do
    it 'only uses included models' do
      RailsAdmin.config.included_models = [Team, League]
      expect(RailsAdmin::AbstractModel.all.collect(&:model)).to eq([League, Team]) # it gets sorted
    end

    it 'does not restrict models if included_models is left empty' do
      RailsAdmin.config.included_models = []
      expect(RailsAdmin::AbstractModel.all.collect(&:model)).to include(Team, League)
    end

    it 'removes excluded models (whitelist - blacklist)' do
      RailsAdmin.config.excluded_models = [Team]
      RailsAdmin.config.included_models = [Team, League]
      expect(RailsAdmin::AbstractModel.all.collect(&:model)).to eq([League])
    end

    it 'excluded? returns true for any model not on the list' do
      RailsAdmin.config.included_models = [Team, League]

      team_config = RailsAdmin::AbstractModel.new('Team').config
      fan_config = RailsAdmin::AbstractModel.new('Fan').config

      expect(fan_config).to be_excluded
      expect(team_config).not_to be_excluded
    end
  end

  describe '.add_extension' do
    before do
      silence_warnings do
        RailsAdmin.const_set('EXTENSIONS', [])
      end
    end

    it 'registers the extension with RailsAdmin' do
      RailsAdmin.add_extension(:example, ExampleModule)
      expect(RailsAdmin::EXTENSIONS.count { |name| name == :example }).to eq(1)
    end

    context 'given an extension with an authorization adapter' do
      it 'registers the adapter' do
        RailsAdmin.add_extension(:example, ExampleModule, authorization: true)
        expect(RailsAdmin::AUTHORIZATION_ADAPTERS[:example]).to eq(ExampleModule::AuthorizationAdapter)
      end
    end

    context 'given an extension with an auditing adapter' do
      it 'registers the adapter' do
        RailsAdmin.add_extension(:example, ExampleModule, auditing: true)
        expect(RailsAdmin::AUDITING_ADAPTERS[:example]).to eq(ExampleModule::AuditingAdapter)
      end
    end

    context 'given an extension with a configuration adapter' do
      it 'registers the adapter' do
        RailsAdmin.add_extension(:example, ExampleModule, configuration: true)
        expect(RailsAdmin::CONFIGURATION_ADAPTERS[:example]).to eq(ExampleModule::ConfigurationAdapter)
      end
    end
  end

  describe '.main_app_name' do
    it 'as a default meaningful dynamic value' do
      expect(RailsAdmin.config.main_app_name.call).to eq(['Dummy App', 'Admin'])
    end

    it 'can be configured' do
      RailsAdmin.config do |config|
        config.main_app_name = %w[static value]
      end
      expect(RailsAdmin.config.main_app_name).to eq(%w[static value])
    end
  end

  describe '.authorize_with' do
    context 'given a key for a extension with authorization' do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, authorization: true)
      end

      it 'initializes the authorization adapter' do
        expect(ExampleModule::AuthorizationAdapter).to receive(:new).with(RailsAdmin::Config)
        RailsAdmin.config do |config|
          config.authorize_with(:example)
        end
        RailsAdmin.config.authorize_with.call
      end

      it 'passes through any additional arguments to the initializer' do
        options = {option: true}
        expect(ExampleModule::AuthorizationAdapter).to receive(:new).with(RailsAdmin::Config, options)
        RailsAdmin.config do |config|
          config.authorize_with(:example, options)
        end
        RailsAdmin.config.authorize_with.call
      end
    end
  end

  describe '.audit_with' do
    context 'given a key for a extension with auditing' do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, auditing: true)
      end

      it 'initializes the auditing adapter' do
        expect(ExampleModule::AuditingAdapter).to receive(:new).with(RailsAdmin::Config)
        RailsAdmin.config do |config|
          config.audit_with(:example)
        end
        RailsAdmin.config.audit_with.call
      end

      it 'passes through any additional arguments to the initializer' do
        options = {option: true}
        expect(ExampleModule::AuditingAdapter).to receive(:new).with(RailsAdmin::Config, options)
        RailsAdmin.config do |config|
          config.audit_with(:example, options)
        end
        RailsAdmin.config.audit_with.call
      end
    end

    context 'given paper_trail as the extension for auditing', active_record: true do
      before do
        class ControllerMock
          def set_paper_trail_whodunnit; end
        end

        module PaperTrail; end

        class Version; end
        RailsAdmin.add_extension(:example, RailsAdmin::Extensions::PaperTrail, auditing: true)
      end

      it 'initializes the auditing adapter' do
        RailsAdmin.config do |config|
          config.audit_with(:example)
        end
        expect { ControllerMock.new.instance_eval(&RailsAdmin.config.audit_with) }.not_to raise_error
      end
    end
  end

  describe '.configure_with' do
    context 'given a key for a extension with configuration' do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, configuration: true)
      end

      it 'initializes configuration adapter' do
        expect(ExampleModule::ConfigurationAdapter).to receive(:new)
        RailsAdmin.config do |config|
          config.configure_with(:example)
        end
      end

      it 'yields the (optionally) provided block, passing the initialized adapter' do
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

  describe '.config' do
    context '.default_search_operator' do
      it 'sets the default_search_operator' do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'
        end
        expect(RailsAdmin::Config.default_search_operator).to eq('starts_with')
      end

      it 'errors on unrecognized search operator' do
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

  describe '.visible_models' do
    it 'passes controller bindings, find visible models, order them' do
      RailsAdmin.config do |config|
        config.included_models = [Player, Fan, Comment, Team]

        config.model Player do
          hide
        end
        config.model Fan do
          weight(-1)
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

      expect(RailsAdmin.config.visible_models(controller: double(_current_user: double(role: :admin), authorized?: true)).collect(&:abstract_model).collect(&:model)).to match_array [Fan, Comment]
    end

    it 'hides unallowed models' do
      RailsAdmin.config do |config|
        config.included_models = [Comment]
      end
      expect(RailsAdmin.config.visible_models(controller: double(authorization_adapter: double(authorized?: true))).collect(&:abstract_model).collect(&:model)).to eq([Comment])
      expect(RailsAdmin.config.visible_models(controller: double(authorization_adapter: double(authorized?: false))).collect(&:abstract_model).collect(&:model)).to eq([])
    end

    it 'does not contain embedded model', mongoid: true do
      RailsAdmin.config do |config|
        config.included_models = [FieldTest, Comment, Embed]
      end

      expect(RailsAdmin.config.visible_models(controller: double(_current_user: double(role: :admin), authorized?: true)).collect(&:abstract_model).collect(&:model)).to match_array [FieldTest, Comment]
    end

    it 'basically does not contain embedded model except model using recursively_embeds_many or recursively_embeds_one', mongoid: true do
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
      expect(RailsAdmin.config.visible_models(controller: double(_current_user: double(role: :admin), authorized?: true)).collect(&:abstract_model).collect(&:model)).to match_array [FieldTest, Comment, RecursivelyEmbedsMany, RecursivelyEmbedsOne]
    end
  end

  describe '.models_pool' do
    it 'should not include classnames start with Concerns::' do
      expect(RailsAdmin::Config.models_pool.select { |m| m.match(/^Concerns::/) }).to be_empty
    end

    it 'includes models in the directory added by config.eager_load_paths' do
      expect(RailsAdmin::Config.models_pool).to include('Basketball')
    end

    it 'should include a model which was configured explicitly' do
      RailsAdmin::Config.model 'PaperTrail::Version' do
        visible false
      end

      expect(RailsAdmin::Config.models_pool).to include('PaperTrail::Version')
    end
  end

  describe '.parent_controller' do
    before do
      class TestController < ActionController::Base; end
    end

    it 'uses default class' do
      expect(RailsAdmin.config.parent_controller).to eq '::ActionController::Base'
    end

    it 'uses other class' do
      RailsAdmin.config do |config|
        config.parent_controller = 'TestController'
      end
      expect(RailsAdmin.config.parent_controller).to eq 'TestController'
    end
  end

  describe '.parent_controller=' do
    context 'if RailsAdmin::ApplicationController is already loaded' do
      before do
        # preload controllers (e.g. when config.eager_load = true)
        RailsAdmin::MainController
      end

      after do
        RailsAdmin::Config.reset
        RailsAdmin.send(:remove_const, :ApplicationController)
        load RailsAdmin::Engine.root.join('app/controllers/rails_admin/application_controller.rb')
      end

      it 'can be changed' do
        RailsAdmin.config.parent_controller = 'ApplicationController'
        expect(RailsAdmin::ApplicationController.superclass).to eq ApplicationController
        expect(RailsAdmin::MainController.superclass.superclass).to eq ApplicationController
      end
    end
  end

  describe '.forgery_protection_settings' do
    it 'uses with: :exception by default' do
      expect(RailsAdmin.config.forgery_protection_settings).to eq(with: :exception)
    end

    it 'allows to customize settings' do
      RailsAdmin.config do |config|
        config.forgery_protection_settings = {with: :null_session}
      end
      expect(RailsAdmin.config.forgery_protection_settings).to eq(with: :null_session)
    end
  end

  describe '.model' do
    let(:fields) { described_class.model(Team).fields }
    before do
      described_class.model Team do
        field :players do
          visible false
        end
      end
    end

    context 'when model expanded' do
      before do
        described_class.model(Team) do
          field :fans
        end
      end
      it 'execute all passed blocks' do
        expect(fields.map(&:name)).to match_array %i[players fans]
      end
    end

    context 'when expand redefine behavior' do
      before do
        described_class.model Team do
          field :players
        end
      end
      it 'execute all passed blocks' do
        expect(fields.find { |f| f.name == :players }.visible).to be true
      end
    end

    context 'when model has no table yet', active_record: true do
      it 'does not try to apply the configuration block' do
        described_class.model(WithoutTable) do
          include_all_fields
        end
      end
    end
  end

  describe '.reset' do
    before do
      RailsAdmin.config do |config|
        config.included_models = %w[Player Team]
      end
      RailsAdmin::AbstractModel.all
      RailsAdmin::Config.reset
      RailsAdmin.config do |config|
        config.excluded_models = ['Player']
      end
    end
    subject { RailsAdmin::AbstractModel.all.map { |am| am.model.name } }

    it 'refreshes the result of RailsAdmin::AbstractModel.all' do
      expect(subject).not_to include 'Player'
      expect(subject).to include 'Team'
    end
  end

  describe '.reload!' do
    before do
      RailsAdmin.config Player do
        field :name
      end
      RailsAdmin.config Team do
        field :color, :integer
      end
    end

    it 'clears current configuration' do
      RailsAdmin::Config.reload!
      expect(RailsAdmin::Config.model(Player).fields.map(&:name)).to include :number
    end

    it 'reloads the configuration from the initializer' do
      RailsAdmin::Config.reload!
      expect(RailsAdmin::Config.model(Team).fields.find { |f| f.name == :color }.type).to eq :hidden
    end
  end
end

module ExampleModule
  class AuthorizationAdapter; end

  class ConfigurationAdapter; end

  class AuditingAdapter; end
end
