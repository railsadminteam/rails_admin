require 'spec_helper'
require 'timecop'

describe "RailsAdmin::Adapters::ActiveRecord", :active_record => true do
  before do
    @like = ::ActiveRecord::Base.configurations[Rails.env]['adapter'] == "postgresql" ? 'ILIKE' : 'LIKE'
  end

  describe "#associations" do
    before :all do
      RailsAdmin::AbstractModel.reset_polymorphic_parents

      class ARBlog < ActiveRecord::Base
        has_many :a_r_posts
        has_many :a_r_comments, :as => :commentable
        belongs_to :librarian, :polymorphic => true
      end

      class ARPost < ActiveRecord::Base
        belongs_to :a_r_blog
        has_and_belongs_to_many :a_r_categories
        has_many :a_r_comments, :as => :commentable
      end

      class ARCategory < ActiveRecord::Base
        has_and_belongs_to_many :a_r_posts
        belongs_to :librarian, :polymorphic => true
      end

      class ARUser < ActiveRecord::Base
        has_one :a_r_profile
        has_many :a_r_categories, :as => :librarian
      end

      class ARProfile < ActiveRecord::Base
        belongs_to :a_r_user
        has_many :a_r_blogs, :as => :librarian
      end

      class ARComment < ActiveRecord::Base
        belongs_to :commentable, :polymorphic => true
      end

      @blog = RailsAdmin::AbstractModel.new(ARBlog)
      @post = RailsAdmin::AbstractModel.new(ARPost)
      @category = RailsAdmin::AbstractModel.new(ARCategory)
      @user = RailsAdmin::AbstractModel.new(ARUser)
      @profile = RailsAdmin::AbstractModel.new(ARProfile)
      @comment = RailsAdmin::AbstractModel.new(ARComment)
    end

    after :all do
      RailsAdmin::AbstractModel.reset_polymorphic_parents
    end

    it "lists associations" do
      expect(@post.associations.map{|a|a[:name].to_s}).to match_array ['a_r_blog', 'a_r_categories', 'a_r_comments']
    end

    it "list associations types in supported [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]" do
      expect((@post.associations + @blog.associations + @user.associations).map{|a|a[:type]}.uniq.map(&:to_s)).to match_array ['belongs_to', 'has_and_belongs_to_many', 'has_many', 'has_one']
    end

    it "has correct parameter of belongs_to association" do
      param = @post.associations.select{|a| a[:name] == :a_r_blog}.first
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :a_r_blog,
        :pretty_name => "A r blog",
        :type => :belongs_to,
        :foreign_key => :a_r_blog_id,
        :foreign_type => nil,
        :as => nil,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil,
      })
      expect(param[:primary_key_proc].call).to eq('id')
      expect(param[:model_proc].call).to eq(ARBlog)
    end

    it "has correct parameter of has_many association" do
      param = @blog.associations.select{|a| a[:name] == :a_r_posts}.first
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :a_r_posts,
        :pretty_name => "A r posts",
        :type => :has_many,
        :foreign_key => :ar_blog_id,
        :foreign_type => nil,
        :as => nil,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil,
      })
      expect(param[:primary_key_proc].call).to eq('id')
      expect(param[:model_proc].call).to eq(ARPost)
    end

    it "has correct parameter of has_and_belongs_to_many association" do
      param = @post.associations.select{|a| a[:name] == :a_r_categories}.first
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :a_r_categories,
        :pretty_name => "A r categories",
        :type => :has_and_belongs_to_many,
        :foreign_key => :ar_post_id,
        :foreign_type => nil,
        :as => nil,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil
      })
      expect(param[:primary_key_proc].call).to eq('id')
      expect(param[:model_proc].call).to eq(ARCategory)
    end

    it "has correct parameter of polymorphic belongs_to association" do
      RailsAdmin::Config.stub!(:models_pool).and_return(["ARBlog", "ARPost", "ARCategory", "ARUser", "ARProfile", "ARComment"])
      param = @comment.associations.select{|a| a[:name] == :commentable}.first
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :commentable,
        :pretty_name => "Commentable",
        :type => :belongs_to,
        :foreign_key => :commentable_id,
        :foreign_type => :commentable_type,
        :as => nil,
        :polymorphic => true,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil
      })
      # Should not be called for polymorphic relations.
      # TODO: Handle this case
      # expect(param[:primary_key_proc].call).to eq('id')
      expect(param[:model_proc].call).to eq([ARBlog, ARPost])
    end

    it "has correct parameter of polymorphic inverse has_many association" do
      param = @blog.associations.select{|a| a[:name] == :a_r_comments}.first
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :a_r_comments,
        :pretty_name => "A r comments",
        :type => :has_many,
        :foreign_key => :commentable_id,
        :foreign_type => nil,
        :as => :commentable,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil
      })
      expect(param[:primary_key_proc].call).to eq('id')
      expect(param[:model_proc].call).to eq(ARComment)
    end


    it 'has correct opposite model lookup for polymorphic associations' do
      RailsAdmin::Config.stub!(:models_pool).and_return(["ARBlog", "ARPost", "ARCategory", "ARUser", "ARProfile", "ARComment"])
      expect(@category.associations.find{|a| a[:name] == :librarian}[:model_proc].call).to eq [ARUser]
      expect(@blog.associations.find{|a| a[:name] == :librarian}[:model_proc].call).to eq [ARProfile]
    end
  end

  describe "#properties" do
    it "returns parameters of string-type field" do
      expect(RailsAdmin::AbstractModel.new('Player').properties.select{|f| f[:name] == :name}).to eq([{:name => :name, :pretty_name => "Name", :type => :string, :length => 100, :nullable? => false, :serial? => false}])
    end

    it "maps serialized attribute to :serialized field type" do
      expect(RailsAdmin::AbstractModel.new('User').properties.find{|f| f[:name] == :roles}).to eq({:name => :roles, :pretty_name => "Roles", :length => 255, :nullable? => true, :serial? => false, :type => :serialized})
    end
  end

  describe "data access method" do
    before do
      @players = FactoryGirl.create_list(:player, 3)
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it "#new returns instance of AbstractObject" do
      expect(@abstract_model.new.object).to be_instance_of(Player)
    end

    it "#get returns instance of AbstractObject" do
      expect(@abstract_model.get(@players.first.id).object).to eq(@players.first)
    end

    it "#get returns nil when id does not exist" do
      expect(@abstract_model.get('abc')).to be_nil
    end

    it "#first returns a player" do
      expect(@players).to include @abstract_model.first
    end

    it "#count returns count of items" do
      expect(@abstract_model.count).to eq(@players.count)
    end

    it "#destroy destroys multiple items" do
      @abstract_model.destroy(@players[0..1])
      expect(Player.all).to eq(@players[2..2])
    end

    it "#where returns filtered results" do
      expect(@abstract_model.where(:name => @players.first.name)).to eq([@players.first])
    end

    describe "#all" do
      it "works without options" do
        expect(@abstract_model.all).to match_array @players
      end

      it "supports eager loading" do
        expect(@abstract_model.all(:include => :team).includes_values).to eq([:team])
      end

      it "supports limiting" do
        expect(@abstract_model.all(:limit => 2)).to have(2).items
      end

      it "supports retrieval by bulk_ids" do
        expect(@abstract_model.all(:bulk_ids => @players[0..1].map(&:id))).to match_array @players[0..1]
      end

      it "supports pagination" do
        expect(@abstract_model.all(:sort => "id", :page => 2, :per => 1)).to eq(@players[1..1])
        expect(@abstract_model.all(:sort => "id", :page => 1, :per => 2)).to eq(@players[1..2].reverse)
      end

      it "supports ordering" do
        expect(@abstract_model.all(:sort => "id", :sort_reverse => true)).to eq(@players.sort)
      end

      it "supports querying" do
        expect(@abstract_model.all(:query => @players[1].name)).to eq(@players[1..1])
      end

      it "supports filtering" do
        expect(@abstract_model.all(:filters => {"name" => {"0000" => {:o => "is", :v => @players[1].name}}})).to eq(@players[1..1])
      end
    end
  end

  describe "#query_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Team')
      @teams = [{}, {:name => 'somewhere foos'}, {:manager => 'foo junior'}].
        map{|h| FactoryGirl.create :team, h}
    end

    it "makes conrrect query" do
      expect(@abstract_model.all(:query => "foo")).to match_array @teams[1..2]
    end
  end

  describe "#filter_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Team')
      @division = FactoryGirl.create :division, :name => 'bar division'
      @teams = [{}, {:division => @division}, {:name => 'somewhere foos', :division => @division}, {:name => 'nowhere foos'}].
        map{|h| FactoryGirl.create :team, h}
    end

    it "makes conrrect query" do
      expect(@abstract_model.all(
        :filters => {"name" => {"0000" => {:o => "like", :v => "foo"}},
                     "division" => {"0001" => {:o => "like", :v => "bar"}}},
        :include => :division
      )).to eq([@teams[2]])
    end
  end

  describe "#build_statement" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
    end

    it "ignores '_discard' operator or value" do
      [["_discard", ""], ["", "_discard"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to be_nil
      end
    end

    it "supports '_blank' operator" do
      [["_blank", ""], ["", "_blank"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name IS NULL OR name = '')"])
      end
    end

    it "supports '_present' operator" do
      [["_present", ""], ["", "_present"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name IS NOT NULL AND name != '')"])
      end
    end

    it "supports '_null' operator" do
      [["_null", ""], ["", "_null"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name IS NULL)"])
      end
    end

    it "supports '_not_null' operator" do
      [["_not_null", ""], ["", "_not_null"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name IS NOT NULL)"])
      end
    end

    it "supports '_empty' operator" do
      [["_empty", ""], ["", "_empty"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name = '')"])
      end
    end

    it "supports '_not_empty' operator" do
      [["_not_empty", ""], ["", "_not_empty"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq(["(name != '')"])
      end
    end

    it "supports boolean type query" do
      ['false', 'f', '0'].each do |value|
        expect(@abstract_model.send(:build_statement, :field, :boolean, value, nil)).to eq(["(field IS NULL OR field = ?)", false])
      end
      ['true', 't', '1'].each do |value|
        expect(@abstract_model.send(:build_statement, :field, :boolean, value, nil)).to eq(["(field = ?)", true])
      end
      expect(@abstract_model.send(:build_statement, :field, :boolean, 'word', nil)).to be_nil
    end

    it "supports integer type query" do
      expect(@abstract_model.send(:build_statement, :field, :integer, "1"   , nil)).to eq(["(field = ?)", 1])
      expect(@abstract_model.send(:build_statement, :field, :integer, 'word', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, "1"   , 'default')).to eq(["(field = ?)", 1])
      expect(@abstract_model.send(:build_statement, :field, :integer, 'word', 'default')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, "1"   , 'between')).to eq(["(field = ?)", 1])
      expect(@abstract_model.send(:build_statement, :field, :integer, 'word', 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['6', ''  , ''  ], 'default')).to eq(["(field = ?)", 6])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['7', '10', ''  ], 'default')).to eq(["(field = ?)", 7])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['8', ''  , '20'], 'default')).to eq(["(field = ?)", 8])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['9', '10', '20'], 'default')).to eq(["(field = ?)", 9])
    end

    it "supports integer type range query" do
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['2', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '3', ''], 'between')).to eq(["(field >= ?)", 3])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '', '5'], 'between')).to eq(["(field <= ?)", 5])
      expect(@abstract_model.send(:build_statement, :field, :integer, [''  , '10', '20'], 'between')).to eq(["(field BETWEEN ? AND ?)", 10, 20])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['15', '10', '20'], 'between')).to eq(["(field BETWEEN ? AND ?)", 10, 20])
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', 'word1', ''     ], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', 'word3', 'word4'], 'between')).to be_nil
    end

    it "supports both decimal and float type queries" do
      expect(@abstract_model.send(:build_statement, :field, :decimal, "1.1", nil)).to eq(["(field = ?)", 1.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, "1.1"   , 'default')).to eq(["(field = ?)", 1.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', 'default')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, "1.1"   , 'between')).to eq(["(field = ?)", 1.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['6.1', ''  , ''  ], 'default')).to eq(["(field = ?)", 6.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['7.1', '10.1', ''  ], 'default')).to eq(["(field = ?)", 7.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['8.1', ''  , '20.1'], 'default')).to eq(["(field = ?)", 8.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['9.1', '10.1', '20.1'], 'default')).to eq(["(field = ?)", 9.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['2.1', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '3.1', ''], 'between')).to eq(["(field >= ?)", 3.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '', '5.1'], 'between')).to eq(["(field <= ?)", 5.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, [''  , '10.1', '20.1'], 'between')).to eq(["(field BETWEEN ? AND ?)", 10.1, 20.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['15.1', '10.1', '20.1'], 'between')).to eq(["(field BETWEEN ? AND ?)", 10.1, 20.1])
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', 'word1', ''     ], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', 'word3', 'word4'], 'between')).to be_nil

      expect(@abstract_model.send(:build_statement, :field, :float, "1.1", nil)).to eq(["(field = ?)", 1.1])
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, "1.1"   , 'default')).to eq(["(field = ?)", 1.1])
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', 'default')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, "1.1"   , 'between')).to eq(["(field = ?)", 1.1])
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['6.1', ''  , ''  ], 'default')).to eq(["(field = ?)", 6.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['7.1', '10.1', ''  ], 'default')).to eq(["(field = ?)", 7.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['8.1', ''  , '20.1'], 'default')).to eq(["(field = ?)", 8.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['9.1', '10.1', '20.1'], 'default')).to eq(["(field = ?)", 9.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['2.1', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '3.1', ''], 'between')).to eq(["(field >= ?)", 3.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '', '5.1'], 'between')).to eq(["(field <= ?)", 5.1])
      expect(@abstract_model.send(:build_statement, :field, :float, [''  , '10.1', '20.1'], 'between')).to eq(["(field BETWEEN ? AND ?)", 10.1, 20.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['15.1', '10.1', '20.1'], 'between')).to eq(["(field BETWEEN ? AND ?)", 10.1, 20.1])
      expect(@abstract_model.send(:build_statement, :field, :float, ['', 'word1', ''     ], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', 'word3', 'word4'], 'between')).to be_nil
    end

    it "supports string type query" do
      expect(@abstract_model.send(:build_statement, :field, :string, "", nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "was")).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "default")).to eq(["(LOWER(field) #{@like} ?)", "%foo%"])
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "like")).to eq(["(LOWER(field) #{@like} ?)", "%foo%"])
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "starts_with")).to eq(["(LOWER(field) #{@like} ?)", "foo%"])
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "ends_with")).to eq(["(LOWER(field) #{@like} ?)", "%foo"])
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "is")).to eq(["(LOWER(field) #{@like} ?)", "foo"])
    end

    it "performs case-insensitive searches" do
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "default")).to eq(["(LOWER(field) #{@like} ?)", "%foo%"])
      expect(@abstract_model.send(:build_statement, :field, :string, "FOO", "default")).to eq(["(LOWER(field) #{@like} ?)", "%foo%"])
    end

    it "supports date type query" do
      expect(@abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } })).to eq(["((field_tests.date_field BETWEEN ? AND ?))", Date.new(2012,1,2), Date.new(2012,1,3)])
      expect(@abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } )).to eq(["((field_tests.date_field >= ?))", Date.new(2012,1,3)])
      expect(@abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } )).to eq(["((field_tests.date_field <= ?))", Date.new(2012,1,2)])
      expect(@abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } )).to eq(["((field_tests.date_field BETWEEN ? AND ?))", Date.new(2012,1,2), Date.new(2012,1,2)])
    end

    it "supports datetime type query" do
      expect(@abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } )).to eq(["((field_tests.datetime_field BETWEEN ? AND ?))", Time.local(2012,1,2), Time.local(2012,1,3).end_of_day])
      expect(@abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } )).to eq(["((field_tests.datetime_field >= ?))", Time.local(2012,1,3)])
      expect(@abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } )).to eq(["((field_tests.datetime_field <= ?))", Time.local(2012,1,2).end_of_day])
      expect(@abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } )).to eq(["((field_tests.datetime_field BETWEEN ? AND ?))", Time.local(2012,1,2), Time.local(2012,1,2).end_of_day])
    end

    it "supports enum type query" do
      expect(@abstract_model.send(:build_statement, :field, :enum, "1", nil)).to eq(["(field IN (?))", ["1"]])
    end
  end

  describe "model attribute method" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it "#scoped returns relation object" do
      expect(@abstract_model.scoped).to be_instance_of(ActiveRecord::Relation)
    end

    it "#table_name works" do
      expect(@abstract_model.table_name).to eq('players')
    end
  end
end
