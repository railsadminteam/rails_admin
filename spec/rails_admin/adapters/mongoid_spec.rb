# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'RailsAdmin::Adapters::Mongoid', mongoid: true do
  it_behaves_like 'a RailsAdmin adapter' do
    let(:adapter_record_type) { Mongoid::Document }
    let(:adapter_property_type) { RailsAdmin::Adapters::Mongoid::Property }
    let(:adapter_association_type) { RailsAdmin::Adapters::Mongoid::Association }
    let(:adapter_missing_id) { '4f4f0824dcf2315093000000' }
  end

  # Behavior shared with the other adapters lives in 'a RailsAdmin adapter'
  # (spec/shared_examples/shared_examples_for_adapters.rb). Only what is specific
  # to Mongoid stays here.
  describe 'data access methods' do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }
    let!(:players) { FactoryBot.create_list(:player, 3) }

    context 'when Mongoid.raise_not_found_error is false' do
      before { allow(Mongoid).to receive(:raise_not_found_error).and_return(false) }

      it '#get returns nil when id does not exist' do
        expect(abstract_model.get('4f4f0824dcf2315093000000')).to be_nil
      end
    end

    describe '#all' do
      it 'supports eager loading' do
        expect(abstract_model.all(include: :team).inclusions.collect(&:class_name)).to eq(['Team'])
      end

      # The 'collection.field' form is a Mongoid-only input format, accepted only
      # when the collection is the model's own.
      it 'supports ordering by a collection-qualified key' do
        expect(abstract_model.all(sort: 'players._id', sort_reverse: true).to_a).to eq(players.sort)
        expect(abstract_model.all(sort: 'players._id', sort_reverse: false).to_a).to eq(players.sort.reverse)
        # To prevent RSpec matcher to call Mongoid::Criteria#== method,
        # (we want to test equality of query result, not of Mongoid criteria)
        # to_a is added to invoke Mongoid query
      end
    end
  end

  describe 'searching on association' do
    describe 'whose type is belongs_to' do
      before do
        RailsAdmin.config Player do
          field :team do
            queryable true
          end
        end
      end

      let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }
      let!(:players) { FactoryBot.create_list(:player, 3) }
      let!(:team) do
        FactoryBot.create(:team, name: 'foobar').tap { |t| t.players << players[1] }
      end

      it 'supports querying' do
        expect(abstract_model.all(query: 'foobar').to_a).to eq(players[1..1])
      end

      it 'supports filtering' do
        expect(abstract_model.all(filters: {'team' => {'0000' => {o: 'is', v: 'foobar'}}}).to_a).to eq(players[1..1])
      end
    end

    describe 'whose type is has_many' do
      before do
        RailsAdmin.config Team do
          field :players do
            queryable true
            searchable :name
          end
        end
      end

      let(:abstract_model) { RailsAdmin::AbstractModel.new('Team') }
      let!(:teams) { FactoryBot.create_list(:team, 3) }
      let!(:players) do
        [{team: teams[1]},
         {team: teams[1], name: 'foobar'},
         {team: teams[2]}].collect { |h| FactoryBot.create :player, h }
      end

      it 'supports querying' do
        expect(abstract_model.all(query: 'foobar').to_a).to eq(teams[1..1])
      end

      it 'supports filtering' do
        expect(abstract_model.all(filters: {'players' => {'0000' => {o: 'is', v: 'foobar'}}}).to_a).to eq(teams[1..1])
      end
    end

    describe 'whose type is has_and_belongs_to_many' do
      before do
        RailsAdmin.config Team do
          field :fans do
            queryable true
            searchable :name
          end
        end
      end

      let(:abstract_model) { RailsAdmin::AbstractModel.new('Team') }
      let!(:teams) { FactoryBot.create_list(:team, 3) }
      let!(:fans) do
        [{}, {name: 'foobar'}, {}].collect { |h| FactoryBot.create :fan, h }.tap do |created|
          teams[1].fans = [created[0], created[1]]
          teams[2].fans << created[2]
        end
      end

      it 'supports querying' do
        expect(abstract_model.all(query: 'foobar').to_a).to eq(teams[1..1])
      end

      it 'supports filtering' do
        expect(abstract_model.all(filters: {'fans' => {'0000' => {o: 'is', v: 'foobar'}}}).to_a).to eq(teams[1..1])
      end
    end

    describe 'whose type is embedded has_many' do
      before do
        RailsAdmin.config FieldTest do
          field :embeds do
            queryable true
            searchable :all
          end
        end
      end

      let(:abstract_model) { RailsAdmin::AbstractModel.new('FieldTest') }
      let!(:field_tests) do
        FactoryBot.create_list(:field_test, 3).tap do |created|
          created[0].embeds.create name: 'foo'
          created[1].embeds.create name: 'bar'
        end
      end

      it 'supports querying' do
        expect(abstract_model.all(query: 'bar').to_a).to eq(field_tests[1..1])
      end

      it 'supports filtering' do
        expect(abstract_model.all(filters: {'embeds' => {'0000' => {o: 'is', v: 'bar'}}}).to_a).to eq(field_tests[1..1])
      end
    end
  end

  describe '#query_scope' do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }
    let!(:players) do
      [{}, {name: 'Many foos'}, {position: 'foo shortage'}].
        collect { |h| FactoryBot.create :player, h }
    end

    it 'makes correct query' do
      expect(abstract_model.all(query: 'foo').to_a).to match_array players[1..2]
    end

    context 'when parsing is not idempotent' do
      before do
        RailsAdmin.config do |c|
          c.model Player do
            field :name do
              def parse_value(value)
                "#{value}s"
              end
            end
          end
        end
      end

      it 'parses value only once' do
        expect(abstract_model.all(query: 'foo')).to match_array players[1..1]
      end
    end
  end

  describe '#filter_scope' do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }
    let!(:team) { FactoryBot.create :team, name: 'king of bar' }
    let!(:players) do
      [{}, {team: team}, {name: 'Many foos', team: team}, {name: 'Great foo'}].
        collect { |h| FactoryBot.create :player, h }
    end

    it 'makes correct query' do
      expect(abstract_model.all(filters: {'name' => {'0000' => {o: 'like', v: 'foo'}}, 'team' => {'0001' => {o: 'like', v: 'bar'}}})).to eq([players[2]])
    end

    context 'when parsing is not idempotent' do
      before do
        RailsAdmin.config do |c|
          c.model Player do
            field :name do
              def parse_value(value)
                "#{value}s"
              end
            end
          end
        end
      end

      it 'parses value only once' do
        expect(abstract_model.all(filters: {'name' => {'0000' => {o: 'like', v: 'foo'}}})).to match_array players[2]
      end
    end
  end

  describe '#build_statement' do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('FieldTest') }

    before do
      I18n.locale = :en
    end

    it "ignores '_discard' operator or value" do
      [['_discard', ''], ['', '_discard']].each do |value, operator|
        expect(abstract_model.send(:build_statement, :name, :string, value, operator)).to be_nil
      end
    end

    it "supports '_blank' operator" do
      [['_blank', ''], ['', '_blank']].each do |value, operator|
        expect(abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(name: {'$in' => [nil, '']})
      end
    end

    it "supports '_present' operator" do
      [['_present', ''], ['', '_present']].each do |value, operator|
        expect(abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(name: {'$nin' => [nil, '']})
      end
    end

    it "supports '_null' operator" do
      [['_null', ''], ['', '_null']].each do |value, operator|
        expect(abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(name: nil)
      end
    end

    it "supports '_not_null' operator" do
      [['_not_null', ''], ['', '_not_null']].each do |value, operator|
        expect(abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(name: {'$ne' => nil})
      end
    end

    it "supports '_empty' operator" do
      [['_empty', ''], ['', '_empty']].each do |value, operator|
        expect(abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(name: '')
      end
    end

    it "supports '_not_empty' operator" do
      [['_not_empty', ''], ['', '_not_empty']].each do |value, operator|
        expect(abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(name: {'$ne' => ''})
      end
    end

    it 'supports boolean type query' do
      %w[false f 0].each do |value|
        expect(abstract_model.send(:build_statement, :field, :boolean, value, nil)).to eq(field: false)
      end
      %w[true t 1].each do |value|
        expect(abstract_model.send(:build_statement, :field, :boolean, value, nil)).to eq(field: true)
      end
      expect(abstract_model.send(:build_statement, :field, :boolean, 'word', nil)).to be_nil
    end

    it 'supports integer type query' do
      expect(abstract_model.send(:build_statement, :field, :integer, '1', nil)).to eq(field: 1)
      expect(abstract_model.send(:build_statement, :field, :integer, 'word', nil)).to be_nil
    end

    it 'supports integer type range query' do
      expect(abstract_model.send(:build_statement, :field, :integer, ['', '', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :integer, ['2', '', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :integer, ['', '3', ''], 'between')).to eq(field: {'$gte' => 3})
      expect(abstract_model.send(:build_statement, :field, :integer, ['', '', '5'], 'between')).to eq(field: {'$lte' => 5})
      expect(abstract_model.send(:build_statement, :field, :integer, ['', '10', '20'], 'between')).to eq(field: {'$gte' => 10, '$lte' => 20})
      expect(abstract_model.send(:build_statement, :field, :integer, %w[15 10 20], 'between')).to eq(field: {'$gte' => 10, '$lte' => 20})
      expect(abstract_model.send(:build_statement, :field, :integer, ['', 'word1', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :integer, ['', '', 'word2'], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :integer, ['', 'word3', 'word4'], 'between')).to be_nil
    end

    it 'supports both decimal and float type queries' do
      expect(abstract_model.send(:build_statement, :field, :decimal, '1.1', nil)).to eq(field: 1.1)
      expect(abstract_model.send(:build_statement, :field, :decimal, 'word', nil)).to be_nil
      expect(abstract_model.send(:build_statement, :field, :decimal, '1.1', 'default')).to eq(field: 1.1)
      expect(abstract_model.send(:build_statement, :field, :decimal, 'word', 'default')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :decimal, '1.1', 'between')).to eq(field: 1.1)
      expect(abstract_model.send(:build_statement, :field, :decimal, 'word', 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :decimal, ['6.1', '', ''], 'default')).to eq(field: 6.1)
      expect(abstract_model.send(:build_statement, :field, :decimal, ['7.1', '10.1', ''], 'default')).to eq(field: 7.1)
      expect(abstract_model.send(:build_statement, :field, :decimal, ['8.1', '', '20.1'], 'default')).to eq(field: 8.1)
      expect(abstract_model.send(:build_statement, :field, :decimal, ['9.1', '10.1', '20.1'], 'default')).to eq(field: 9.1)
      expect(abstract_model.send(:build_statement, :field, :decimal, ['', '', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :decimal, ['2.1', '', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :decimal, ['', '3.1', ''], 'between')).to eq(field: {'$gte' => 3.1})
      expect(abstract_model.send(:build_statement, :field, :decimal, ['', '', '5.1'], 'between')).to eq(field: {'$lte' => 5.1})
      expect(abstract_model.send(:build_statement, :field, :decimal, ['', '10.1', '20.1'], 'between')).to eq(field: {'$gte' => 10.1, '$lte' => 20.1})
      expect(abstract_model.send(:build_statement, :field, :decimal, ['15.1', '10.1', '20.1'], 'between')).to eq(field: {'$gte' => 10.1, '$lte' => 20.1})
      expect(abstract_model.send(:build_statement, :field, :decimal, ['', 'word1', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :decimal, ['', '', 'word2'], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :decimal, ['', 'word3', 'word4'], 'between')).to be_nil

      expect(abstract_model.send(:build_statement, :field, :float, '1.1', nil)).to eq(field: 1.1)
      expect(abstract_model.send(:build_statement, :field, :float, 'word', nil)).to be_nil
      expect(abstract_model.send(:build_statement, :field, :float, '1.1', 'default')).to eq(field: 1.1)
      expect(abstract_model.send(:build_statement, :field, :float, 'word', 'default')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :float, '1.1', 'between')).to eq(field: 1.1)
      expect(abstract_model.send(:build_statement, :field, :float, 'word', 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :float, ['6.1', '', ''], 'default')).to eq(field: 6.1)
      expect(abstract_model.send(:build_statement, :field, :float, ['7.1', '10.1', ''], 'default')).to eq(field: 7.1)
      expect(abstract_model.send(:build_statement, :field, :float, ['8.1', '', '20.1'], 'default')).to eq(field: 8.1)
      expect(abstract_model.send(:build_statement, :field, :float, ['9.1', '10.1', '20.1'], 'default')).to eq(field: 9.1)
      expect(abstract_model.send(:build_statement, :field, :float, ['', '', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :float, ['2.1', '', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :float, ['', '3.1', ''], 'between')).to eq(field: {'$gte' => 3.1})
      expect(abstract_model.send(:build_statement, :field, :float, ['', '', '5.1'], 'between')).to eq(field: {'$lte' => 5.1})
      expect(abstract_model.send(:build_statement, :field, :float, ['', '10.1', '20.1'], 'between')).to eq(field: {'$gte' => 10.1, '$lte' => 20.1})
      expect(abstract_model.send(:build_statement, :field, :float, ['15.1', '10.1', '20.1'], 'between')).to eq(field: {'$gte' => 10.1, '$lte' => 20.1})
      expect(abstract_model.send(:build_statement, :field, :float, ['', 'word1', ''], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :float, ['', '', 'word2'], 'between')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :float, ['', 'word3', 'word4'], 'between')).to be_nil
    end

    it 'supports string type query' do
      expect(abstract_model.send(:build_statement, :field, :string, '', nil)).to be_nil
      expect(abstract_model.send(:build_statement, :field, :string, 'foo', 'was')).to be_nil
      expect(abstract_model.send(:build_statement, :field, :string, 'foo', 'default')).to eq(field: /foo/i)
      expect(abstract_model.send(:build_statement, :field, :string, 'foo', 'like')).to eq(field: /foo/i)
      expect(abstract_model.send(:build_statement, :field, :string, 'foo', 'not_like')).to eq(field: /^((?!foo).)*$/i)
      expect(abstract_model.send(:build_statement, :field, :string, 'foo', 'starts_with')).to eq(field: /^foo/i)
      expect(abstract_model.send(:build_statement, :field, :string, 'foo', 'ends_with')).to eq(field: /foo$/i)
      expect(abstract_model.send(:build_statement, :field, :string, 'foo', 'is')).to eq(field: 'foo')
    end

    it 'supports date type query' do
      expect(abstract_model.send(:filter_scope, FieldTest, 'date_field' => {'1' => {v: ['', '2012-01-02', '2012-01-03'], o: 'between'}}).selector).to eq('$and' => [{'date_field' => {'$gte' => Date.new(2012, 1, 2), '$lte' => Date.new(2012, 1, 3)}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'date_field' => {'1' => {v: ['', '2012-01-03', ''], o: 'between'}}).selector).to eq('$and' => [{'date_field' => {'$gte' => Date.new(2012, 1, 3)}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'date_field' => {'1' => {v: ['', '', '2012-01-02'], o: 'between'}}).selector).to eq('$and' => [{'date_field' => {'$lte' => Date.new(2012, 1, 2)}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'date_field' => {'1' => {v: ['2012-01-02'], o: 'default'}}).selector).to eq('$and' => [{'date_field' => Date.new(2012, 1, 2)}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'date_field' => {'1' => {v: [], o: 'today'}}).selector).to eq('$and' => [{'date_field' => Date.today}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'date_field' => {'1' => {v: [], o: 'yesterday'}}).selector).to eq('$and' => [{'date_field' => Date.yesterday}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'date_field' => {'1' => {v: [], o: 'this_week'}}).selector).to eq('$and' => [{'date_field' => {'$gte' => Date.today.beginning_of_week, '$lte' => Date.today.end_of_week}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'date_field' => {'1' => {v: [], o: 'last_week'}}).selector).to eq('$and' => [{'date_field' => {'$gte' => 1.week.ago.to_date.beginning_of_week, '$lte' => 1.week.ago.to_date.end_of_week}}])
    end

    it 'supports datetime type query' do
      expect(abstract_model.send(:filter_scope, FieldTest, 'datetime_field' => {'1' => {v: ['', '2012-01-02T12:00:00', '2012-01-03T12:00:00'], o: 'between'}}).selector).to eq('$and' => [{'datetime_field' => {'$gte' => Time.zone.local(2012, 1, 2, 12), '$lte' => Time.zone.local(2012, 1, 3, 12)}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'datetime_field' => {'1' => {v: ['', '2012-01-03T12:00:00', ''], o: 'between'}}).selector).to eq('$and' => [{'datetime_field' => {'$gte' => Time.zone.local(2012, 1, 3, 12)}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'datetime_field' => {'1' => {v: ['', '', '2012-01-02T12:00:00'], o: 'between'}}).selector).to eq('$and' => [{'datetime_field' => {'$lte' => Time.zone.local(2012, 1, 2, 12)}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'datetime_field' => {'1' => {v: ['2012-01-02T12:00:00'], o: 'default'}}).selector).to eq('$and' => [{'datetime_field' => Time.zone.local(2012, 1, 2, 12)}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'datetime_field' => {'1' => {v: [], o: 'today'}}).selector).to eq('$and' => [{'datetime_field' => {'$gte' => Date.today.beginning_of_day, '$lte' => Date.today.end_of_day}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'datetime_field' => {'1' => {v: [], o: 'yesterday'}}).selector).to eq('$and' => [{'datetime_field' => {'$gte' => Date.yesterday.beginning_of_day, '$lte' => Date.yesterday.end_of_day}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'datetime_field' => {'1' => {v: [], o: 'this_week'}}).selector).to eq('$and' => [{'datetime_field' => {'$gte' => Date.today.beginning_of_week.beginning_of_day, '$lte' => Date.today.end_of_week.end_of_day}}])
      expect(abstract_model.send(:filter_scope, FieldTest, 'datetime_field' => {'1' => {v: [], o: 'last_week'}}).selector).to eq('$and' => [{'datetime_field' => {'$gte' => 1.week.ago.to_date.beginning_of_week.beginning_of_day, '$lte' => 1.week.ago.to_date.end_of_week.end_of_day}}])
    end

    it 'supports enum type query' do
      expect(abstract_model.send(:build_statement, :field, :enum, '1', nil)).to eq(field: {'$in' => ['1']})
    end
  end

  describe 'model attribute method' do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }

    it '#scoped returns relation object' do
      expect(abstract_model.scoped).to be_instance_of(Mongoid::Criteria)
    end

    it '#table_name works' do
      expect(abstract_model.table_name).to eq('players')
    end
  end

  describe 'serialization' do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('FieldTest') }
    let(:controller) { RailsAdmin::MainController.new }

    it 'accepts array value' do
      params = HashWithIndifferentAccess.new(array_field: '[1, 3]')
      controller.send(:sanitize_params_for!, 'create', abstract_model.config, params)
      expect(params[:array_field]).to eq([1, 3])
    end

    it 'accepts hash value' do
      params = HashWithIndifferentAccess.new(hash_field: '{a: 1, b: 3}')
      controller.send(:sanitize_params_for!, 'create', abstract_model.config, params)
      expect(params[:hash_field]).to eq('a' => 1, 'b' => 3)
    end
  end
end
