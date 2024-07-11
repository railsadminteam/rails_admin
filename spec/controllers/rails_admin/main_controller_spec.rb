

require 'spec_helper'

RSpec.describe RailsAdmin::MainController, type: :controller do
  routes { RailsAdmin::Engine.routes }

  def get(action, params)
    super action, params: params
  end

  before do
    controller.instance_variable_set :@action, RailsAdmin::Config::Actions.find(:index)
  end

  describe '#check_for_cancel' do
    before do
      allow(controller).to receive(:back_or_index) { raise StandardError.new('redirected back') }
    end

    it 'redirects to back if params[:bulk_ids] is nil when params[:bulk_action] is present' do
      expect { get :bulk_delete, model_name: 'player', bulk_action: 'bulk_delete' }.to raise_error('redirected back')
    end

    it 'does not redirect to back if params[:bulk_ids] and params[:bulk_action] is present' do
      expect { get :bulk_delete, model_name: 'player', bulk_action: 'bulk_delete', bulk_ids: [1] }.not_to raise_error
    end
  end

  describe '#get_sort_hash' do
    context 'options sortable is a hash' do
      before do
        RailsAdmin.config('Player') do
          configure :team do
            sortable do
              :'team.name'
            end
          end
        end
      end

      it 'returns the option with no changes' do
        controller.params = {sort: 'team', model_name: 'players'}
        expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))).to eq(sort: :'team.name', sort_reverse: true)
      end
    end

    context 'when default sort_by points to a field with a table reference for sortable' do
      before do
        RailsAdmin.config('Player') do
          base do
            field :name do
              sortable 'teams.name'
            end
          end

          list do
            sort_by :name
          end
        end
      end

      it 'returns the query referenced in the sortable' do
        expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))).to eq(sort: 'teams.name', sort_reverse: true)
      end
    end

    context 'with a virtual field' do
      before do
        RailsAdmin.config('Player') do
          base do
            field :virtual do
              sortable :name
            end
          end

          list do
            sort_by :virtual
          end
        end
      end

      it 'returns the query referenced in the sortable' do
        expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))).to match(sort: /["`]?players["`]?\.["`]?name["`]?/, sort_reverse: true)
      end
    end

    it 'works with belongs_to associations with label method virtual' do
      controller.params = {sort: 'parent_category', model_name: 'categories'}
      expect(controller.send(:get_sort_hash, RailsAdmin.config(Category))).to eq(sort: 'categories.parent_category_id', sort_reverse: true)
    end

    context 'using mongoid', mongoid: true do
      it 'gives back the remote table with label name, as it does not support joins' do
        controller.params = {sort: 'team', model_name: 'players'}
        expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))).to match(sort: 'players.team_id', sort_reverse: true)
      end
    end

    context 'using active_record', active_record: true do
      let(:connection_config) do
        if ActiveRecord::Base.respond_to?(:connection_db_config)
          ActiveRecord::Base.connection_db_config.configuration_hash
        else
          ActiveRecord::Base.connection_config
        end
      end

      it 'gives back the local column' do
        controller.params = {sort: 'team', model_name: 'players'}
        expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))).to match(sort: /^["`]teams["`]\.["`]name["`]$/, sort_reverse: true)
      end

      it 'quotes the table and column names it returns as :sort' do
        controller.params = {sort: 'team', model_name: 'players'}
        case connection_config[:adapter]
        when 'mysql2'
          expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))[:sort]).to eq '`teams`.`name`'
        else
          expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))[:sort]).to eq '"teams"."name"'
        end
      end
    end
  end

  describe '#bulk_action' do
    before do
      RailsAdmin.config do |config|
        config.actions do
          dashboard
          index do
            visible do
              raise # This shouldn't be invoked
            end
          end
          bulk_delete
        end
      end
    end

    it 'retrieves actions using :bulkable scope' do
      expect { post :bulk_action, params: {model_name: 'player', bulk_action: 'bulk_delete', bulk_ids: [1]} }.not_to raise_error
    end
  end

  describe '#list_entries called from view' do
    before do
      @teams = FactoryBot.create_list(:team, 21)
      controller.params = {model_name: 'teams'}
    end

    it 'paginates' do
      expect(controller.list_entries(RailsAdmin.config(Team), :index, nil, false).to_a.length).to eq(21)
      expect(controller.list_entries(RailsAdmin.config(Team), :index, nil, true).to_a.length).to eq(20)
    end
  end

  describe '#list_entries called from view with kaminari custom param_name' do
    before do
      @teams = FactoryBot.create_list(:team, 21)
      controller.params = {model_name: 'teams'}
      Kaminari.config.param_name = :pagina
    end

    after do
      Kaminari.config.param_name = :page
    end

    it 'paginates' do
      expect(controller.list_entries(RailsAdmin.config(Team), :index, nil, false).to_a.length).to eq(21)
      expect(controller.list_entries(RailsAdmin.config(Team), :index, nil, true).to_a.length).to eq(20)
    end
  end

  describe '#list_entries called with bulk_ids' do
    before do
      @teams = FactoryBot.create_list(:team, 21)
      controller.params = {model_name: 'teams', bulk_action: 'bulk_delete', bulk_ids: @teams.collect(&:id)}
    end

    it 'does not paginate' do
      expect(controller.list_entries(RailsAdmin.config(Team), :bulk_delete).to_a.length).to eq(21)
    end
  end

  describe '#list_entries for associated_collection' do
    before do
      @team = FactoryBot.create :team
      controller.params = {associated_collection: 'players', current_action: 'update', source_abstract_model: 'team', source_object_id: @team.id, model_name: 'player', action: 'index'}
      controller.get_model # set @model_config for Team
    end

    it "doesn't scope associated collection records when associated_collection_scope is nil" do
      @players = FactoryBot.create_list(:player, 2)

      RailsAdmin.config Team do
        field :players do
          associated_collection_scope false
        end
      end

      expect(controller.list_entries.to_a.length).to eq(@players.size)
    end

    it 'scopes associated collection records according to associated_collection_scope' do
      @players = FactoryBot.create_list(:player, 4)

      RailsAdmin.config Team do
        field :players do
          associated_collection_scope do
            proc { |scope| scope.limit(3) }
          end
        end
      end

      expect(controller.list_entries.to_a.length).to eq(3)
    end

    it 'scopes associated collection records according to bindings' do
      @team.revenue = BigDecimal('3')
      @team.save

      @players = FactoryBot.create_list(:player, 5)

      RailsAdmin.config Team do
        field :players do
          associated_collection_scope do
            team = bindings[:object]
            proc do |scope|
              scope.limit(team.revenue)
            end
          end
        end
      end

      expect(controller.list_entries.to_a.length).to eq(@team.revenue.to_i)
    end

    it 'limits associated collection records number to 30 if cache_all is false' do
      @players = FactoryBot.create_list(:player, 40)

      RailsAdmin.config Team do
        field :players do
          associated_collection_cache_all false
        end
      end
      expect(controller.list_entries.to_a.length).to eq(30)
    end

    it "doesn't limit associated collection records number to 30 if cache_all is true" do
      @players = FactoryBot.create_list(:player, 40)

      RailsAdmin.config Team do
        field :players do
          associated_collection_cache_all true
        end
      end
      expect(controller.list_entries.length).to eq(@players.size)
    end

    it 'orders associated collection records by id, descending' do
      @players = FactoryBot.create_list(:player, 3)

      expect(controller.list_entries.to_a).to eq(@players.sort_by(&:id).reverse)
    end
  end

  describe '#action_missing' do
    it 'raises error when action is not found' do
      expect(RailsAdmin::Config::Actions).to receive(:find).and_return(nil)
      expect { get :index, model_name: 'player' }.to raise_error AbstractController::ActionNotFound
    end
  end

  describe '#respond_to_missing?' do
    it 'returns the result based on existence of action' do
      expect(controller.send(:respond_to_missing?, :index, false)).to be true
      expect(controller.send(:respond_to_missing?, :invalid_action, false)).to be false
    end
  end

  describe '#get_collection' do
    let(:team) { FactoryBot.create :team }
    let!(:player) { FactoryBot.create :player, team: team }
    let(:model_config) { RailsAdmin.config(Team) }
    let(:abstract_model) { model_config.abstract_model }
    before do
      controller.params = {model_name: 'team'}
    end

    it 'performs eager-loading with `eager_load true`' do
      RailsAdmin.config Team do
        field :players do
          eager_load true
        end
      end
      expect(abstract_model).to receive(:all).with(hash_including(include: [:players]), nil).once.and_call_original
      controller.send(:get_collection, model_config, nil, false).to_a
    end

    it 'performs eager-loading with custom eager_load value' do
      RailsAdmin.config Team do
        field :players do
          eager_load players: :draft
        end
      end
      expect(abstract_model).to receive(:all).with(hash_including(include: [{players: :draft}]), nil).once.and_call_original
      controller.send(:get_collection, model_config, nil, false).to_a
    end

    context 'on export' do
      before do
        controller.instance_variable_set :@action, RailsAdmin::Config::Actions.find(:export)
      end

      it 'uses the export section' do
        RailsAdmin.config Team do
          export do
            field :players do
              eager_load true
            end
          end
        end
        expect(abstract_model).to receive(:all).with(hash_including(include: [:players]), nil).once.and_call_original
        controller.send(:get_collection, model_config, nil, false).to_a
      end
    end
  end

  describe 'index' do
    it "uses target model's primary key" do
      @user = FactoryBot.create :managing_user
      @team = FactoryBot.create :managed_team, user: @user
      get :index, model_name: 'managing_user', source_object_id: @team.id, source_abstract_model: 'managing_user', associated_collection: 'teams', current_action: :create, compact: true, format: :json
      expect(response.body).to match(/"id":"#{@user.id}"/)
    end

    context 'as JSON' do
      it 'returns strings' do
        FactoryBot.create :player, team: (FactoryBot.create :team)
        get :index, model_name: 'player', source_object_id: Team.first.id, source_abstract_model: 'team', associated_collection: 'players', current_action: :create, compact: true, format: :json
        expect(JSON.parse(response.body).first['id']).to be_a_kind_of String
      end
    end

    context 'when authorizing requests with pundit' do
      if defined?(Devise::Test)
        include Devise::Test::ControllerHelpers
      else
        include Devise::TestHelpers
      end

      controller(RailsAdmin::MainController) do
        include defined?(::Pundit::Authorization) ? ::Pundit::Authorization : ::Pundit
        after_action :verify_authorized
      end

      it 'performs authorization' do
        RailsAdmin.config do |c|
          c.authorize_with(:pundit)
          c.authenticate_with { warden.authenticate! scope: :user }
          c.current_user_method(&:current_user)
        end
        login_as FactoryBot.create :user, roles: [:admin]
        player = FactoryBot.create :player, team: (FactoryBot.create :team)
        expect { get :show, model_name: 'player', id: player.id }.not_to raise_error
      end
    end
  end

  describe 'sanitize_params_for!' do
    context 'with datetime' do
      before do
        ActionController::Parameters.permit_all_parameters = false

        RailsAdmin.config Comment do
          configure :created_at do
            show
          end
        end

        RailsAdmin.config NestedFieldTest do
          configure :created_at do
            show
          end
        end

        controller.params = ActionController::Parameters.new(
          'field_test' => {
            'unallowed_field' => "I shouldn't be here",
            'datetime_field' => '2010-08-01T00:00:00',
            'nested_field_tests_attributes' => {
              'new_1330520162002' => {
                'comment_attributes' => {
                  'unallowed_field' => "I shouldn't be here",
                  'created_at' => '2010-08-02T00:00:00',
                },
                'created_at' => '2010-08-03T00:00:00',
              },
            },
            'comment_attributes' => {
              'unallowed_field' => "I shouldn't be here",
              'created_at' => '2010-08-04T00:00:00',
            },
          },
        )
        controller.send(:sanitize_params_for!, :create, RailsAdmin.config(FieldTest), controller.params['field_test'])
      end

      after do
        ActionController::Parameters.permit_all_parameters = true
      end

      it 'sanitize params recursively in nested forms' do
        expect(controller.params[:field_test].to_h).to eq(
          'datetime_field' => ::Time.zone.parse('Sun, 01 Aug 2010 00:00:00 UTC +00:00'),
          'nested_field_tests_attributes' => {
            'new_1330520162002' => {
              'comment_attributes' => {
                'created_at' => ::Time.zone.parse('Mon, 02 Aug 2010 00:00:00 UTC +00:00'),
              },
              'created_at' => ::Time.zone.parse('Tue, 03 Aug 2010 00:00:00 UTC +00:00'),
            },
          },
          'comment_attributes' => {
            'created_at' => ::Time.zone.parse('Wed, 04 Aug 2010 00:00:00 UTC +00:00'),
          },
        )
      end

      it 'enforces permit!' do
        expect(controller.params['field_test'].permitted?).to be_truthy
        expect(controller.params['field_test']['nested_field_tests_attributes'].values.first.permitted?).to be_truthy
        expect(controller.params['field_test']['comment_attributes'].permitted?).to be_truthy
      end
    end

    it 'allows for delete method with Carrierwave' do
      RailsAdmin.config FieldTest do
        field :carrierwave_asset
        field :carrierwave_assets
        field :dragonfly_asset
        field :paperclip_asset do
          delete_method :delete_paperclip_asset
        end
        if defined?(ActiveStorage)
          field :active_storage_asset do
            delete_method :remove_active_storage_asset
          end
        end
        if defined?(ActiveStorage)
          field :active_storage_assets do
            delete_method :remove_active_storage_assets
          end
        end
        if defined?(Shrine)
          field :shrine_asset do
            delete_method :remove_shrine_asset
          end
        end
      end
      controller.params = HashWithIndifferentAccess.new(
        'field_test' => {
          'carrierwave_asset' => 'test',
          'carrierwave_asset_cache' => 'test',
          'remove_carrierwave_asset' => 'test',
          'carrierwave_assets' => 'test',
          'dragonfly_asset' => 'test',
          'remove_dragonfly_asset' => 'test',
          'retained_dragonfly_asset' => 'test',
          'paperclip_asset' => 'test',
          'delete_paperclip_asset' => 'test',
          'should_not_be_here' => 'test',
        }.merge(defined?(ActiveStorage) ? {'active_storage_asset' => 'test', 'remove_active_storage_asset' => 'test', 'active_storage_assets' => 'test', 'remove_active_storage_assets' => 'test'} : {}).
          merge(defined?(Shrine) ? {'shrine_asset' => 'test', 'remove_shrine_asset' => 'test'} : {}),
      )

      controller.send(:sanitize_params_for!, :create, RailsAdmin.config(FieldTest), controller.params['field_test'])
      expect(controller.params[:field_test].to_h).to eq({
        'carrierwave_asset' => 'test',
        'remove_carrierwave_asset' => 'test',
        'carrierwave_asset_cache' => 'test',
        'carrierwave_assets' => 'test',
        'dragonfly_asset' => 'test',
        'remove_dragonfly_asset' => 'test',
        'retained_dragonfly_asset' => 'test',
        'paperclip_asset' => 'test',
        'delete_paperclip_asset' => 'test',
      }.merge(defined?(ActiveStorage) ? {'active_storage_asset' => 'test', 'remove_active_storage_asset' => 'test', 'active_storage_assets' => 'test', 'remove_active_storage_assets' => 'test'} : {}).
        merge(defined?(Shrine) ? {'shrine_asset' => 'test', 'remove_shrine_asset' => 'test'} : {}))
    end

    it 'allows for polymorphic associations parameters' do
      RailsAdmin.config Comment do
        field :commentable
      end

      controller.params = HashWithIndifferentAccess.new(
        'comment' => {
          'commentable_id' => 'test',
          'commentable_type' => 'test',
        },
      )
      controller.send(:sanitize_params_for!, :create, RailsAdmin.config(Comment), controller.params['comment'])
      expect(controller.params[:comment].to_h).to eq(
        'commentable_id' => 'test',
        'commentable_type' => 'test',
      )
    end
  end

  describe 'back_or_index' do
    before do
      allow(controller).to receive(:index_path).and_return(index_path)
    end

    let(:index_path) { '/' }

    it 'returns back to index when return_to is not defined' do
      controller.params = {}
      expect(controller.send(:back_or_index)).to eq(index_path)
    end

    it 'returns back to return_to url when it starts with same protocol and host' do
      return_to_url = "http://#{request.host}/teams"
      controller.params = {return_to: return_to_url}
      expect(controller.send(:back_or_index)).to eq(return_to_url)
    end

    it 'returns back to return_to url when it contains a path' do
      return_to_url = '/teams'
      controller.params = {return_to: return_to_url}
      expect(controller.send(:back_or_index)).to eq(return_to_url)
    end

    it 'returns back to index path when return_to path does not start with slash' do
      return_to_url = 'teams'
      controller.params = {return_to: return_to_url}
      expect(controller.send(:back_or_index)).to eq(index_path)
    end

    it 'returns back to index path when return_to url does not start with full protocol' do
      return_to_url = "#{request.host}/teams"
      controller.params = {return_to: return_to_url}
      expect(controller.send(:back_or_index)).to eq(index_path)
    end

    it 'returns back to index path when return_to url starts with double slash' do
      return_to_url = "//#{request.host}/teams"
      controller.params = {return_to: return_to_url}
      expect(controller.send(:back_or_index)).to eq(index_path)
    end

    it 'returns back to index path when return_to url starts with triple slash' do
      return_to_url = "///#{request.host}/teams"
      controller.params = {return_to: return_to_url}
      expect(controller.send(:back_or_index)).to eq(index_path)
    end

    it 'returns back to index path when return_to url does not have host' do
      return_to_url = 'http:///teams'
      controller.params = {return_to: return_to_url}
      expect(controller.send(:back_or_index)).to eq(index_path)
    end

    it 'returns back to index path when return_to url starts with different protocol' do
      return_to_url = "other://#{request.host}/teams"
      controller.params = {return_to: return_to_url}
      expect(controller.send(:back_or_index)).to eq(index_path)
    end

    it 'returns back to index path when return_to does not start with the same protocol and host' do
      controller.params = {return_to: "http://google.com?#{request.host}"}
      expect(controller.send(:back_or_index)).to eq(index_path)
    end
  end
end
