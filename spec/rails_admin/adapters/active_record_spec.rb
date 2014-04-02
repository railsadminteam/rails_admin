require 'spec_helper'
require 'timecop'

describe 'RailsAdmin::Adapters::ActiveRecord', active_record: true do
  before do
    @like = ::ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'postgresql' ? 'ILIKE' : 'LIKE'
  end

  describe '#associations' do
    it 'returns Association class' do
      expect(RailsAdmin::AbstractModel.new(Player).associations.first).
        to be_a_kind_of RailsAdmin::Adapters::ActiveRecord::Association
    end
  end

  describe '#properties' do
    it 'returns Property class' do
      expect(RailsAdmin::AbstractModel.new(Player).properties.first).
        to be_a_kind_of RailsAdmin::Adapters::ActiveRecord::Property
    end
  end

  describe 'data access methods' do
    before do
      @players = FactoryGirl.create_list(:player, 3)
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it '#new returns instance of AbstractObject' do
      expect(@abstract_model.new.object).to be_instance_of(Player)
    end

    it '#get returns instance of AbstractObject' do
      expect(@abstract_model.get(@players.first.id).object).to eq(@players.first)
    end

    it '#get returns nil when id does not exist' do
      expect(@abstract_model.get('abc')).to be_nil
    end

    it '#first returns a player' do
      expect(@players).to include @abstract_model.first
    end

    it '#count returns count of items' do
      expect(@abstract_model.count).to eq(@players.count)
    end

    it '#destroy destroys multiple items' do
      @abstract_model.destroy(@players[0..1])
      expect(Player.all).to eq(@players[2..2])
    end

    it '#where returns filtered results' do
      expect(@abstract_model.where(name: @players.first.name)).to eq([@players.first])
    end

    describe '#all' do
      it 'works without options' do
        expect(@abstract_model.all).to match_array @players
      end

      it 'supports eager loading' do
        expect(@abstract_model.all(include: :team).includes_values).to eq([:team])
      end

      it 'supports limiting' do
        expect(@abstract_model.all(limit: 2)).to have(2).items
      end

      it 'supports retrieval by bulk_ids' do
        expect(@abstract_model.all(bulk_ids: @players[0..1].collect(&:id))).to match_array @players[0..1]
      end

      it 'supports pagination' do
        expect(@abstract_model.all(sort: 'id', page: 2, per: 1)).to eq(@players[1..1])
        expect(@abstract_model.all(sort: 'id', page: 1, per: 2)).to eq(@players[1..2].reverse)
      end

      it 'supports ordering' do
        expect(@abstract_model.all(sort: 'id', sort_reverse: true)).to eq(@players.sort)
      end

      it 'supports querying' do
        expect(@abstract_model.all(query: @players[1].name)).to eq(@players[1..1])
      end

      it 'supports filtering' do
        expect(@abstract_model.all(filters: {'name' => {'0000' => {o: 'is', v: @players[1].name}}})).to eq(@players[1..1])
      end
    end
  end

  describe '#query_conditions' do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Team')
      @teams = [{}, {name: 'somewhere foos'}, {manager: 'foo junior'}].
        collect { |h| FactoryGirl.create :team, h }
    end

    it 'makes correct query' do
      expect(@abstract_model.all(query: 'foo')).to match_array @teams[1..2]
    end

    context "when field's searchable_columns is empty" do
      before do
        RailsAdmin.config do |c|
          c.model Team do
            field :players
          end
        end
      end

      it 'does not break' do
        expect { @abstract_model.all(query: 'foo') }.not_to raise_error
      end
    end
  end

  describe '#filter_conditions' do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Team')
      @division = FactoryGirl.create :division, name: 'bar division'
      @teams = [{}, {division: @division}, {name: 'somewhere foos', division: @division}, {name: 'nowhere foos'}].
        collect { |h| FactoryGirl.create :team, h }
    end

    context 'without configuration' do
      before do
        Rails.configuration.stub(:database_configuration) { nil }
      end

      after do
        Rails.configuration.unstub(:database_configuration)
      end

      it 'does not raise error' do
        expect { @abstract_model.all(filters: {'name' => {'0000' => {o: 'like', v: 'foo'}}}) }.to_not raise_error
      end
    end

    it 'makes correct query' do
      expect(@abstract_model.all(filters: {'name' => {'0000' => {o: 'like', v: 'foo'}}, 'division' => {'0001' => {o: 'like', v: 'bar'}}}, include: :division)).to eq([@teams[2]])
    end
  end

  describe '#build_statement' do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
    end

    it "ignores '_discard' operator or value" do
      [['_discard', ''], ['', '_discard']].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to be_nil
      end
    end

    it "supports '_blank' operator" do
      [['_blank', ''], ['', '_blank']].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name IS NULL OR name = '')"])
      end
    end

    it "supports '_present' operator" do
      [['_present', ''], ['', '_present']].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name IS NOT NULL AND name != '')"])
      end
    end

    it "supports '_null' operator" do
      [['_null', ''], ['', '_null']].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(['(name IS NULL)'])
      end
    end

    it "supports '_not_null' operator" do
      [['_not_null', ''], ['', '_not_null']].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(['(name IS NOT NULL)'])
      end
    end

    it "supports '_empty' operator" do
      [['_empty', ''], ['', '_empty']].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name = '')"])
      end
    end

    it "supports '_not_empty' operator" do
      [['_not_empty', ''], ['', '_not_empty']].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name != '')"])
      end
    end

    it 'supports boolean type query' do
      %w[false f 0].each do |value|
        expect(@abstract_model.send(:build_statement, :field, :boolean, value, nil)).to eq(['(field IS NULL OR field = ?)', false])
      end
      %w[true t 1].each do |value|
        expect(@abstract_model.send(:build_statement, :field, :boolean, value, nil)).to eq(['(field = ?)', true])
      end
      expect(@abstract_model.send(:build_statement, :field, :boolean, 'word', nil)).to be_nil
    end

    it 'supports integer type query' do
      expect(@abstract_model.send(:build_statement, :field, :integer, '1'   , nil)).to eq(['(field = ?)', 1])
      expect(@abstract_model.send(:build_statement, :field, :integer, 'word', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, '1'   , 'default')).to eq(['(field = ?)', 1])
      expect(@abstract_model.send(:build_statement, :field, :integer, 'word', 'default')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, '1'   , 'between')).to eq(['(field = ?)', 1])
      expect(@abstract_model.send(:build_statement, :field, :integer, 'word', 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['6', ''  , ''], 'default')).to eq(['(field = ?)', 6])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['7', '10', ''], 'default')).to eq(['(field = ?)', 7])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['8', ''  , '20'], 'default')).to eq(['(field = ?)', 8])
      expect(@abstract_model.send(:build_statement, :field, :integer, %w[9 10 20], 'default')).to eq(['(field = ?)', 9])
    end

    it 'supports integer type range query' do
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['2', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '3', ''], 'between')).to eq(['(field >= ?)', 3])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '', '5'], 'between')).to eq(['(field <= ?)', 5])
      expect(@abstract_model.send(:build_statement, :field, :integer, [''  , '10', '20'], 'between')).to eq(['(field BETWEEN ? AND ?)', 10, 20])
      expect(@abstract_model.send(:build_statement, :field, :integer, %w[15 10 20], 'between')).to eq(['(field BETWEEN ? AND ?)', 10, 20])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', 'word1', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', 'word3', 'word4'], 'between')).to be_nil
    end

    it 'supports both decimal and float type queries' do
      expect(@abstract_model.send(:build_statement, :field, :decimal, '1.1', nil)).to eq(['(field = ?)', 1.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, '1.1'   , 'default')).to eq(['(field = ?)', 1.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', 'default')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, '1.1'   , 'between')).to eq(['(field = ?)', 1.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['6.1', ''  , ''], 'default')).to eq(['(field = ?)', 6.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['7.1', '10.1', ''], 'default')).to eq(['(field = ?)', 7.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['8.1', ''  , '20.1'], 'default')).to eq(['(field = ?)', 8.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['9.1', '10.1', '20.1'], 'default')).to eq(['(field = ?)', 9.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['2.1', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '3.1', ''], 'between')).to eq(['(field >= ?)', 3.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '', '5.1'], 'between')).to eq(['(field <= ?)', 5.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, [''  , '10.1', '20.1'], 'between')).to eq(['(field BETWEEN ? AND ?)', 10.1, 20.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['15.1', '10.1', '20.1'], 'between')).to eq(['(field BETWEEN ? AND ?)', 10.1, 20.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', 'word1', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', 'word3', 'word4'], 'between')).to be_nil

      expect(@abstract_model.send(:build_statement, :field, :float, '1.1', nil)).to eq(['(field = ?)', 1.1])
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, '1.1'   , 'default')).to eq(['(field = ?)', 1.1])
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', 'default')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, '1.1'   , 'between')).to eq(['(field = ?)', 1.1])
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['6.1', ''  , ''], 'default')).to eq(['(field = ?)', 6.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['7.1', '10.1', ''], 'default')).to eq(['(field = ?)', 7.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['8.1', ''  , '20.1'], 'default')).to eq(['(field = ?)', 8.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['9.1', '10.1', '20.1'], 'default')).to eq(['(field = ?)', 9.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['2.1', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '3.1', ''], 'between')).to eq(['(field >= ?)', 3.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '', '5.1'], 'between')).to eq(['(field <= ?)', 5.1])
      expect(@abstract_model.send(:build_statement, :field, :float, [''  , '10.1', '20.1'], 'between')).to eq(['(field BETWEEN ? AND ?)', 10.1, 20.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['15.1', '10.1', '20.1'], 'between')).to eq(['(field BETWEEN ? AND ?)', 10.1, 20.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['', 'word1', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', 'word3', 'word4'], 'between')).to be_nil
    end

    it 'supports string type query' do
      expect(@abstract_model.send(:build_statement, :field, :string, '', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :string, 'foo', 'was')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :string, 'foo', 'default')).to eq(["(LOWER(field) #{@like} ?)", '%foo%'])
      expect(@abstract_model.send(:build_statement, :field, :string, 'foo', 'like')).to eq(["(LOWER(field) #{@like} ?)", '%foo%'])
      expect(@abstract_model.send(:build_statement, :field, :string, 'foo', 'starts_with')).to eq(["(LOWER(field) #{@like} ?)", 'foo%'])
      expect(@abstract_model.send(:build_statement, :field, :string, 'foo', 'ends_with')).to eq(["(LOWER(field) #{@like} ?)", '%foo'])
      expect(@abstract_model.send(:build_statement, :field, :string, 'foo', 'is')).to eq(["(LOWER(field) #{@like} ?)", 'foo'])
    end

    it 'performs case-insensitive searches' do
      expect(@abstract_model.send(:build_statement, :field, :string, 'foo', 'default')).to eq(["(LOWER(field) #{@like} ?)", '%foo%'])
      expect(@abstract_model.send(:build_statement, :field, :string, 'FOO', 'default')).to eq(["(LOWER(field) #{@like} ?)", '%foo%'])
    end

    it 'supports date type query' do
      scope = FieldTest.all
      expect(@abstract_model.send(:filter_scope, scope, 'date_field' => {'1' => {v: ['', '01/02/2012', '01/03/2012'], o: 'between'}}).where_values).to eq(["(field_tests.date_field BETWEEN '2012-01-02' AND '2012-01-03')"])
      expect(@abstract_model.send(:filter_scope, scope, 'date_field' => {'1' => {v: ['', '01/03/2012', ''], o: 'between'}}).where_values).to eq(["(field_tests.date_field >= '2012-01-03')"])
      expect(@abstract_model.send(:filter_scope, scope, 'date_field' => {'1' => {v: ['', '', '01/02/2012'], o: 'between'}}).where_values).to eq(["(field_tests.date_field <= '2012-01-02')"])
      expect(@abstract_model.send(:filter_scope, scope, 'date_field' => {'1' => {v: ['01/02/2012'], o: 'default'}}).where_values).to eq(["(field_tests.date_field BETWEEN '2012-01-02' AND '2012-01-02')"])
    end

    it 'supports datetime type query' do
      scope = FieldTest.all
      expect(@abstract_model.send(:filter_scope, scope,  'datetime_field' => {'1' => {v: ['', '01/02/2012', '01/03/2012'], o: 'between'}}).where_values).to eq(scope.where(['(field_tests.datetime_field BETWEEN ? AND ?)', Time.local(2012, 1, 2), Time.local(2012, 1, 3).end_of_day]).where_values)
      expect(@abstract_model.send(:filter_scope, scope, 'datetime_field' => {'1' => {v: ['', '01/03/2012', ''], o: 'between'}}).where_values).to eq(scope.where(['(field_tests.datetime_field >= ?)', Time.local(2012, 1, 3)]).where_values)
      expect(@abstract_model.send(:filter_scope, scope, 'datetime_field' => {'1' => {v: ['', '', '01/02/2012'], o: 'between'}}).where_values).to eq(scope.where(['(field_tests.datetime_field <= ?)', Time.local(2012, 1, 2).end_of_day]).where_values)
      expect(@abstract_model.send(:filter_scope, scope, 'datetime_field' => {'1' => {v: ['01/02/2012'], o: 'default'}}).where_values).to eq(scope.where(['(field_tests.datetime_field BETWEEN ? AND ?)', Time.local(2012, 1, 2), Time.local(2012, 1, 2).end_of_day]).where_values)
    end

    it 'supports enum type query' do
      expect(@abstract_model.send(:build_statement, :field, :enum, '1', nil)).to eq(['(field IN (?))', ['1']])
    end
  end

  describe 'model attribute method' do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it '#scoped returns relation object' do
      expect(@abstract_model.scoped).to be_a_kind_of(ActiveRecord::Relation)
    end

    it '#table_name works' do
      expect(@abstract_model.table_name).to eq('players')
    end
  end
end
