require 'spec_helper'
require 'timecop'

describe 'RailsAdmin::Adapters::ActiveRecord', :active_record => true do
  before do
    @like = ::ActiveRecord::Base.configurations[Rails.env]['adapter'] == "postgresql" ? 'ILIKE' : 'LIKE'
  end

  describe '#associations' do
    before :all do
      RailsAdmin::AbstractModel.reset_polymorphic_parents

      class ARBlog < ActiveRecord::Base
        has_many :a_r_posts
        has_many :a_r_comments, :as => :commentable
      end

      class ARPost < ActiveRecord::Base
        belongs_to :a_r_blog
        has_and_belongs_to_many :a_r_categories
        has_many :a_r_comments, :as => :commentable
      end

      class ARCategory < ActiveRecord::Base
        has_and_belongs_to_many :a_r_posts
      end

      class ARUser < ActiveRecord::Base
        has_one :a_r_profile
      end

      class ARProfile < ActiveRecord::Base
        belongs_to :a_r_user
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

    it 'lists associations' do
      @post.associations.map{|a|a[:name].to_s}.should =~ ['a_r_blog', 'a_r_categories', 'a_r_comments']
    end

    it 'list associations types in supported [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]' do
      (@post.associations + @blog.associations + @user.associations).map{|a|a[:type]}.uniq.map(&:to_s).should =~ ['belongs_to', 'has_and_belongs_to_many', 'has_many', 'has_one']
    end

    it "has correct parameter of belongs_to association" do
      param = @post.associations.select{|a| a[:name] == :a_r_blog}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:a_r_blog,
        :pretty_name=>"A r blog",
        :type=>:belongs_to,
        :foreign_key=>:a_r_blog_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:primary_key_proc].call.should == 'id'
      param[:model_proc].call.should == ARBlog
    end

    it "has correct parameter of has_many association" do
      param = @blog.associations.select{|a| a[:name] == :a_r_posts}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:a_r_posts,
        :pretty_name=>"A r posts",
        :type=>:has_many,
        :foreign_key=>:ar_blog_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:primary_key_proc].call.should == 'id'
      param[:model_proc].call.should == ARPost
    end

    it "has correct parameter of has_and_belongs_to_many association" do
      param = @post.associations.select{|a| a[:name] == :a_r_categories}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:a_r_categories,
        :pretty_name=>"A r categories",
        :type=>:has_and_belongs_to_many,
        :foreign_key=>:ar_post_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:primary_key_proc].call.should == 'id'
      param[:model_proc].call.should == ARCategory
    end

    it "has correct parameter of polymorphic belongs_to association" do
      RailsAdmin::Config.stub!(:models_pool).and_return(["ARBlog", "ARPost", "ARCategory", "ARUser", "ARProfile", "ARComment"])
      param = @comment.associations.select{|a| a[:name] == :commentable}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:commentable,
        :pretty_name=>"Commentable",
        :type=>:belongs_to,
        :foreign_key=>:commentable_id,
        :foreign_type=>:commentable_type,
        :as=>nil,
        :polymorphic=>true,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      # param[:primary_key_proc].call.should == 'id' Should not be called for polymorphic relations. Todo, Handle this niver
      param[:model_proc].call.should == [ARBlog, ARPost]
    end

    it "has correct parameter of polymorphic inverse has_many association" do
      param = @blog.associations.select{|a| a[:name] == :a_r_comments}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:a_r_comments,
        :pretty_name=>"A r comments",
        :type=>:has_many,
        :foreign_key=>:commentable_id,
        :foreign_type=>nil,
        :as=>:commentable,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:primary_key_proc].call.should == 'id'
      param[:model_proc].call.should == ARComment
    end
  end
  

  describe "#properties" do
    it "returns parameters of string-type field" do
      RailsAdmin::AbstractModel.new('Player').properties.select{|f| f[:name] == :name}.should ==
        [{:name => :name, :pretty_name => "Name", :type => :string, :length => 100, :nullable? => false, :serial? => false}]
    end

    it "maps serialized attribute to :serialized field type" do
      RailsAdmin::AbstractModel.new('User').properties.find{|f| f[:name] == :roles}.should ==
        {:name => :roles, :pretty_name => "Roles", :length => 255, :nullable? => true, :serial? => false, :type => :serialized}
    end
  end

  describe "data access method" do
    before do
      @players = FactoryGirl.create_list(:player, 3)
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it "#new returns instance of AbstractObject" do
      @abstract_model.new.object.should be_instance_of(Player)
    end

    it "#get returns instance of AbstractObject" do
      @abstract_model.get(@players.first.id).object.should == @players.first
    end

    it "#get returns nil when id does not exist" do
      @abstract_model.get('abc').should be_nil
    end

    it "#first returns a player" do
      @players.should include @abstract_model.first
    end

    it "#count returns count of items" do
      @abstract_model.count.should == @players.count
    end

    it "#destroy destroys multiple items" do
      @abstract_model.destroy(@players[0..1])
      Player.all.should == @players[2..2]
    end

    it "#where returns filtered results" do
      @abstract_model.where(:name => @players.first.name).should == [@players.first]
    end

    describe "#all" do
      it "works without options" do
        @abstract_model.all.should =~ @players
      end

      it "supports eager loading" do
        @abstract_model.all(:include => :team).includes_values.should == [:team]
      end

      it "supports limiting" do
        @abstract_model.all(:limit => 2).should have(2).items
      end

      it "supports retrieval by bulk_ids" do
        @abstract_model.all(:bulk_ids => @players[0..1].map(&:id)).should =~ @players[0..1]
      end

      it "supports pagination" do
        @abstract_model.all(:sort => "id", :page => 2, :per => 1).should == @players[1..1]
        @abstract_model.all(:sort => "id", :page => 1, :per => 2).should == @players[1..2].reverse
      end

      it "supports ordering" do
        @abstract_model.all(:sort => "id", :sort_reverse => true).should == @players.sort
      end

      it "supports querying" do
        @abstract_model.all(:query => @players[1].name).should == @players[1..1]
      end

      it "supports filtering" do
        @abstract_model.all(:filters => {"name" => {"0000" => {:o=>"is", :v=>@players[1].name}}}).should == @players[1..1]
      end
    end
  end

  describe "#query_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Team')
      @teams = [{}, {:name=>'somewhere foos'}, {:manager=>'foo junior'}].
        map{|h| FactoryGirl.create :team, h}
    end

    it "makes conrrect query" do
      @abstract_model.all(:query => "foo").should =~ @teams[1..2]
    end
  end

  describe "#filter_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Team')
      @division = FactoryGirl.create :division, :name => 'bar division'
      @teams = [{}, {:division=>@division}, {:name=>'somewhere foos', :division=>@division}, {:name=>'nowhere foos'}].
        map{|h| FactoryGirl.create :team, h}
    end

    it "makes conrrect query" do
      @abstract_model.all(
        :filters => {"name" => {"0000" => {:o=>"like", :v=>"foo"}},
                     "division" => {"0001" => {:o=>"like", :v=>"bar"}}},
        :include => :division
      ).should == [@teams[2]]
    end
  end

  describe "#build_statement" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
    end

    it "ignores '_discard' operator or value" do
      [["_discard", ""], ["", "_discard"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should be_nil
      end
    end

    it "supports '_blank' operator" do
      [["_blank", ""], ["", "_blank"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == ["(name IS NULL OR name = '')"]
      end
    end

    it "supports '_present' operator" do
      [["_present", ""], ["", "_present"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == ["(name IS NOT NULL AND name != '')"]
      end
    end

    it "supports '_null' operator" do
      [["_null", ""], ["", "_null"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == ["(name IS NULL)"]
      end
    end

    it "supports '_not_null' operator" do
      [["_not_null", ""], ["", "_not_null"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == ["(name IS NOT NULL)"]
      end
    end

    it "supports '_empty' operator" do
      [["_empty", ""], ["", "_empty"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == ["(name = '')"]
      end
    end

    it "supports '_not_empty' operator" do
      [["_not_empty", ""], ["", "_not_empty"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == ["(name != '')"]
      end
    end

    it "supports boolean type query" do
      ['false', 'f', '0'].each do |value|
        @abstract_model.send(:build_statement, :field, :boolean, value, nil).should == ["(field IS NULL OR field = ?)", false]
      end
      ['true', 't', '1'].each do |value|
        @abstract_model.send(:build_statement, :field, :boolean, value, nil).should == ["(field = ?)", true]
      end
      @abstract_model.send(:build_statement, :field, :boolean, 'word', nil).should be_nil
    end

    it "supports integer type query" do
      @abstract_model.send(:build_statement, :field, :integer, "1", nil).should == ["(field = ?)", 1]
      @abstract_model.send(:build_statement, :field, :integer, 'word', nil).should be_nil
    end

    it "supports decimal type query" do
      @abstract_model.send(:build_statement, :field, :decimal, "1.1", nil).should == ["(field = ?)", 1.1]
      @abstract_model.send(:build_statement, :field, :decimal, 'word', nil).should be_nil
    end

    it "supports string type query" do
      @abstract_model.send(:build_statement, :field, :string, "", nil).should be_nil
      @abstract_model.send(:build_statement, :field, :string, "foo", "was").should be_nil
      @abstract_model.send(:build_statement, :field, :string, "foo", "default").should == ["(field #{@like} ?)", "%foo%"]
      @abstract_model.send(:build_statement, :field, :string, "foo", "like").should == ["(field #{@like} ?)", "%foo%"]
      @abstract_model.send(:build_statement, :field, :string, "foo", "starts_with").should == ["(field #{@like} ?)", "foo%"]
      @abstract_model.send(:build_statement, :field, :string, "foo", "ends_with").should == ["(field #{@like} ?)", "%foo"]
      @abstract_model.send(:build_statement, :field, :string, "foo", "is").should == ["(field #{@like} ?)", "foo"]
    end


    it 'supports date type query' do
      @abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } }).should == ["((field_tests.date_field BETWEEN ? AND ?))", Date.new(2012,1,2), Date.new(2012,1,3)]
      @abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } ).should == ["((field_tests.date_field >= ?))", Date.new(2012,1,3)]
      @abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } ).should == ["((field_tests.date_field <= ?))", Date.new(2012,1,2)]
      @abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } ).should == ["((field_tests.date_field BETWEEN ? AND ?))", Date.new(2012,1,2), Date.new(2012,1,2)]
    end

    it 'supports datetime type query' do
      @abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } ).should == ["((field_tests.datetime_field BETWEEN ? AND ?))", Time.local(2012,1,2), Time.local(2012,1,3).end_of_day]
      @abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } ).should == ["((field_tests.datetime_field >= ?))", Time.local(2012,1,3)]
      @abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } ).should == ["((field_tests.datetime_field <= ?))", Time.local(2012,1,2).end_of_day]
      @abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } ).should == ["((field_tests.datetime_field BETWEEN ? AND ?))", Time.local(2012,1,2), Time.local(2012,1,2).end_of_day]
    end

    it "supports enum type query" do
      @abstract_model.send(:build_statement, :field, :enum, "1", nil).should == ["(field IN (?))", ["1"]]
    end
  end

  describe "model attribute method" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it "#scoped returns relation object" do
      @abstract_model.scoped.should be_instance_of(ActiveRecord::Relation)
    end

    it "#table_name works" do
      @abstract_model.table_name.should == 'players'
    end
  end
end
