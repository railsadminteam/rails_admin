require 'spec_helper'
require 'timecop'

describe 'RailsAdmin::Adapters::Mongoid', :mongoid => true do
  describe '#associations' do
    before :all do
      RailsAdmin::AbstractModel.reset_polymorphic_parents

      class MongoBlog
        include Mongoid::Document
        references_many :mongo_posts
        references_many :mongo_comments, :as => :commentable
      end

      class MongoPost
        include Mongoid::Document
        referenced_in :mongo_blog
        has_and_belongs_to_many :mongo_categories
        references_many :mongo_comments, :as => :commentable
      end

      class MongoCategory
        include Mongoid::Document
        has_and_belongs_to_many :mongo_posts
      end

      class MongoUser
        include Mongoid::Document
        references_one :mongo_profile
        field :name, :type => String
        field :message, :type => String
        field :short_text, :type => String

        validates :short_text, :length => {:maximum => 255}
      end

      class MongoProfile
        include Mongoid::Document
        referenced_in :mongo_user
      end

      class MongoComment
        include Mongoid::Document
        referenced_in :commentable, :polymorphic => true
      end

      @blog = RailsAdmin::AbstractModel.new(MongoBlog)
      @post = RailsAdmin::AbstractModel.new(MongoPost)
      @category = RailsAdmin::AbstractModel.new(MongoCategory)
      @user = RailsAdmin::AbstractModel.new(MongoUser)
      @profile = RailsAdmin::AbstractModel.new(MongoProfile)
      @comment = RailsAdmin::AbstractModel.new(MongoComment)
    end

    after :all do
      RailsAdmin::AbstractModel.reset_polymorphic_parents
    end

    it 'lists associations' do
      @post.associations.map{|a|a[:name].to_s}.sort.should == ['mongo_blog', 'mongo_categories', 'mongo_comments']
    end

    it 'reads correct and know types in [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]' do
      (@post.associations + @blog.associations + @user.associations).map{|a|a[:type].to_s}.uniq.sort.should == ['belongs_to', 'has_and_belongs_to_many', 'has_many', 'has_one']
    end

    it "has correct parameter of belongs_to association" do
      param = @post.associations.select{|a| a[:name] == :mongo_blog}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:mongo_blog,
        :pretty_name=>"Mongo blog",
        :type=>:belongs_to,
        :foreign_key=>:mongo_blog_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:primary_key_proc].call.should == :_id
      param[:model_proc].call.should == MongoBlog
    end

    it "has correct parameter of has_many association" do
      param = @blog.associations.select{|a| a[:name] == :mongo_posts}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:mongo_posts,
        :pretty_name=>"Mongo posts",
        :type=>:has_many,
        :foreign_key=>:mongo_blog_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:primary_key_proc].call.should == :_id
      param[:model_proc].call.should == MongoPost
    end

    it "has correct parameter of has_and_belongs_to_many association" do
      param = @post.associations.select{|a| a[:name] == :mongo_categories}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:mongo_categories,
        :pretty_name=>"Mongo categories",
        :type=>:has_and_belongs_to_many,
        :foreign_key=>:mongo_category_ids,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:primary_key_proc].call.should == :_id
      param[:model_proc].call.should == MongoCategory
    end

    it "has correct parameter of polymorphic belongs_to association" do
      RailsAdmin::Config.stub!(:models_pool).and_return(["MongoBlog", "MongoPost", "MongoCategory", "MongoUser", "MongoProfile", "MongoComment"])
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
      param[:primary_key_proc].call.should == :_id
      param[:model_proc].call.should == [MongoBlog, MongoPost]
    end

    it "has correct parameter of polymorphic inverse has_many association" do
      RailsAdmin::Config.stub!(:models_pool).and_return(["MongoBlog", "MongoPost", "MongoCategory", "MongoUser", "MongoProfile", "MongoComment"])
      param = @blog.associations.select{|a| a[:name] == :mongo_comments}.first
      param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }.should == {
        :name=>:mongo_comments,
        :pretty_name=>"Mongo comments",
        :type=>:has_many,
        :foreign_key=>:commentable_id,
        :foreign_type=>nil,
        :as=>:commentable,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:primary_key_proc].call.should == :_id
      param[:model_proc].call.should == MongoComment
    end
  end

  describe "#properties" do
    before :all do
      @abstract_model = RailsAdmin::AbstractModel.new(FieldTest)
    end

    it "maps Mongoid column types to RA types" do
      @abstract_model.properties.select{|p| %w(_id _type array_field big_decimal_field
        boolean_field bson_object_id_field date_field datetime_field float_field
        hash_field integer_field name object_field short_text subject text_field time_field title).
        include? p[:name].to_s}.sort{|a,b| a[:name].to_s <=> b[:name].to_s }.should == [
        { :name => :_id,
          :pretty_name => "Id",
          :nullable? => true,
          :serial? => true,
          :type => :bson_object_id,
          :length => nil },
        { :name => :_type,
          :pretty_name => "Type",
          :nullable? => true,
          :serial? => false,
          :type => :mongoid_type,
          :length => 1024 },
        { :name => :array_field,
          :pretty_name => "Array field",
          :nullable? => true,
          :serial? => false,
          :type => :serialized,
          :length => nil },
        { :name => :big_decimal_field,
          :pretty_name => "Big decimal field",
          :nullable? => true,
          :serial? => false,
          :type => :decimal,
          :length => nil },
        { :name => :boolean_field,
          :pretty_name => "Boolean field",
          :nullable? => true,
          :serial? => false,
          :type => :boolean,
          :length => nil },
        { :name => :bson_object_id_field,
          :pretty_name => "Bson object id field",
          :nullable? => true,
          :serial? => false,
          :type => :bson_object_id,
          :length => nil },
        { :name => :date_field,
          :pretty_name => "Date field",
          :nullable? => true,
          :serial? => false,
          :type => :date,
          :length => nil },
        { :name => :datetime_field,
          :pretty_name => "Datetime field",
          :nullable? => true,
          :serial? => false,
          :type => :datetime,
          :length => nil },
        { :name => :float_field,
          :pretty_name => "Float field",
          :nullable? => true,
          :serial? => false,
          :type => :float,
          :length => nil },
        { :name => :hash_field,
          :pretty_name => "Hash field",
          :nullable? => true,
          :serial? => false,
          :type => :serialized,
          :length => nil },
        { :name => :integer_field,
          :pretty_name => "Integer field",
          :nullable? => true,
          :serial? => false,
          :type => :integer,
          :length => nil },
        { :name => :name,
          :pretty_name => "Name",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :object_field,
          :pretty_name => "Object field",
          :nullable? => true,
          :serial? => false,
          :type => :bson_object_id,
          :length => nil },
        { :name => :short_text,
          :pretty_name => "Short text",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :subject,
          :pretty_name => "Subject",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :text_field,
          :pretty_name => "Text field",
          :nullable? => true,
          :serial? => false,
          :type => :text,
          :length => nil },
        { :name => :time_field,
          :pretty_name => "Time field",
          :nullable? => true,
          :serial? => false,
          :type => :datetime,
          :length => nil },
        { :name => :title,
          :pretty_name => "Title",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 }
      ]
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
      @abstract_model.get(@players.first.id.to_s).object.should == @players.first
    end

    it "#get returns nil when id does not exist" do
      @abstract_model.get('4f4f0824dcf2315093000000').should be_nil
    end

    it "#first returns first item" do
      @abstract_model.first.should == @players.first
    end

    it "#count returns count of items" do
      @abstract_model.count.should == @players.count
    end

    it "#destroy destroys multiple items" do
      @abstract_model.destroy(@players[0..1])
      Player.all.should == @players[2..2]
    end

    describe "#all" do
      it "works without options" do
        @abstract_model.all.sort.should == @players.sort
      end

      it "supports eager loading" do
        @abstract_model.all(:include => :team).inclusions.map{|i| i.class_name}.should == ["Team"]
      end

      it "supports limiting" do
        @abstract_model.all(:limit => 2).to_a.count.should == 2
      end

      it "supports retrieval by bulk_ids" do
        @abstract_model.all(:bulk_ids => @players[0..1].map{|player| player.id.to_s }).
          sort.should == @players[0..1].sort
      end

      it "supports pagination" do
        @abstract_model.all(:sort => 'players._id', :page => 2, :per => 1).to_a.should == @players[1..1]
        # To prevent RSpec matcher to call Mongoid::Criteria#== method,
        # (we want to test equality of query result, not of Mongoid criteria)
        # to_a is added to invoke Mongoid query
      end

      it "supports ordering" do
        @abstract_model.all(:sort => 'players._id', :sort_reverse => true).to_a.should == @players.sort
        @abstract_model.all(:sort => 'players._id', :sort_reverse => false).to_a.should == @players.sort.reverse
      end

      it "supports querying" do
        @abstract_model.all(:query => @players[1].name).should == @players[1..1]
      end

      it "supports filtering" do
        @abstract_model.all(:filters => {"name" => {"0000" => {:o=>"is", :v=>@players[1].name}}}).should == @players[1..1]
      end

      it "ignores non-existent field name on filtering" do
        lambda{ @abstract_model.all(:filters => {"dummy" => {"0000" => {:o=>"is", :v=>@players[1].name}}}) }.should_not raise_error
      end
    end
  end

  describe "searching on association" do
    describe "whose type is belongs_to" do
      before do
        RailsAdmin.config Player do
          field :team do
            queryable true
          end
        end
        @players = FactoryGirl.create_list(:player, 3)
        @team = FactoryGirl.create :team, :name => 'foobar'
        @team.players << @players[1]
        @abstract_model = RailsAdmin::AbstractModel.new('Player')
      end

      it "supports querying" do
        @abstract_model.all(:query => 'foobar').to_a.should == @players[1..1]
      end

      it "supports filtering" do
        @abstract_model.all(:filters => {"team" => {"0000" => {:o=>"is", :v=>'foobar'}}}).to_a.should == @players[1..1]
      end
    end

    describe "whose type is has_many" do
      before do
        RailsAdmin.config Team do
          field :players do
            queryable true
            searchable :all
          end
        end
        @teams = FactoryGirl.create_list(:team, 3)
        @players = [{:team => @teams[1]},
                     {:team => @teams[1], :name => 'foobar'},
                     {:team => @teams[2]}].map{|h| FactoryGirl.create :player, h}
        @abstract_model = RailsAdmin::AbstractModel.new('Team')
      end

      it "supports querying" do
        @abstract_model.all(:query => 'foobar').to_a.should == @teams[1..1]
      end

      it "supports filtering" do
        @abstract_model.all(:filters => {"players" => {"0000" => {:o=>"is", :v=>'foobar'}}}).to_a.should == @teams[1..1]
      end
    end

    describe "whose type is has_and_belongs_to_many" do
      before do
        RailsAdmin.config Team do
          field :fans do
            queryable true
            searchable :all
          end
        end
        @teams = FactoryGirl.create_list(:team, 3)
        @fans = [{}, {:name => 'foobar'}, {}].map{|h| FactoryGirl.create :fan, h}
        @teams[1].fans = [@fans[0], @fans[1]]
        @teams[2].fans << @fans[2]
        @abstract_model = RailsAdmin::AbstractModel.new('Team')
      end

      it "supports querying" do
        @abstract_model.all(:query => 'foobar').to_a.should == @teams[1..1]
      end

      it "supports filtering" do
        @abstract_model.all(:filters => {"fans" => {"0000" => {:o=>"is", :v=>'foobar'}}}).to_a.should == @teams[1..1]
      end
    end
  end

  describe "#query_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
      @players = [{}, {:name=>'Many foos'}, {:position=>'foo shortage'}].
        map{|h| FactoryGirl.create :player, h}
    end

    it "makes conrrect query" do
      @abstract_model.all(:query => "foo").sort.should == @players[1..2]
    end
  end

  describe "#filter_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
      @team = FactoryGirl.create :team, :name => 'king of bar'
      @players = [{}, {:team=>@team}, {:name=>'Many foos', :team=>@team}, {:name=>'Great foo'}].
        map{|h| FactoryGirl.create :player, h}
    end

    it "makes conrrect query" do
      @abstract_model.all(:filters =>
        {"name" => {"0000" => {:o=>"like", :v=>"foo"}},
         "team" => {"0001" => {:o=>"like", :v=>"bar"}}}
      ).should == [@players[2]]
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
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == {:name=>{"$in"=>[nil, ""]}}
      end
    end

    it "supports '_present' operator" do
      [["_present", ""], ["", "_present"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == {:name=>{"$nin"=>[nil, ""]}}
      end
    end

    it "supports '_null' operator" do
      [["_null", ""], ["", "_null"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == {:name=>nil}
      end
    end

    it "supports '_not_null' operator" do
      [["_not_null", ""], ["", "_not_null"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == {:name=>{"$ne"=>nil}}
      end
    end

    it "supports '_empty' operator" do
      [["_empty", ""], ["", "_empty"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == {:name=>""}
      end
    end

    it "supports '_not_empty' operator" do
      [["_not_empty", ""], ["", "_not_empty"]].each do |value, operator|
        @abstract_model.send(:build_statement, :name, :string, value, operator).should == {:name=>{"$ne"=>""}}
      end
    end

    it "supports boolean type query" do
      ['false', 'f', '0'].each do |value|
        @abstract_model.send(:build_statement, :field, :boolean, value, nil).should == {:field => false}
      end
      ['true', 't', '1'].each do |value|
        @abstract_model.send(:build_statement, :field, :boolean, value, nil).should == {:field => true}
      end
      @abstract_model.send(:build_statement, :field, :boolean, 'word', nil).should be_nil
    end

    it "supports integer type query" do
      @abstract_model.send(:build_statement, :field, :integer, "1", nil).should == {:field => 1}
      @abstract_model.send(:build_statement, :field, :integer, 'word', nil).should be_nil
    end

    it "supports string type query" do
      @abstract_model.send(:build_statement, :field, :string, "", nil).should be_nil
      @abstract_model.send(:build_statement, :field, :string, "foo", "was").should be_nil
      @abstract_model.send(:build_statement, :field, :string, "foo", "default").should == {:field=>/foo/}
      @abstract_model.send(:build_statement, :field, :string, "foo", "like").should == {:field=>/foo/}
      @abstract_model.send(:build_statement, :field, :string, "foo", "starts_with").should == {:field=>/^foo/}
      @abstract_model.send(:build_statement, :field, :string, "foo", "ends_with").should == {:field=>/foo$/}
      @abstract_model.send(:build_statement, :field, :string, "foo", "is").should == {:field=>'foo'}
    end

    context 'filters on dates' do
      it 'lists elements within outbound limits' do
        date_format = I18n.t("admin.misc.filter_date_format", :default => I18n.t("admin.misc.filter_date_format", :locale => :en)).gsub('dd', '%d').gsub('mm', '%m').gsub('yy', '%Y')

        FieldTest.create!(:date_field => Date.strptime("01/01/2012", date_format))
        FieldTest.create!(:date_field => Date.strptime("01/02/2012", date_format))
        FieldTest.create!(:date_field => Date.strptime("01/03/2012", date_format))
        FieldTest.create!(:date_field => Date.strptime("01/04/2012", date_format))
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/02/2012"], :o => 'between' } } } ).count.should == 1
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } ).count.should == 1

      end
    end

    it "supports enum type query" do
      @abstract_model.send(:build_statement, :field, :enum, "1", nil).should == {:field => {"$in" => ["1"]}}
    end
  end

  describe "model attribute method" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it "#scoped returns relation object" do
      @abstract_model.scoped.should be_instance_of(Mongoid::Criteria)
    end

    it "#table_name works" do
      @abstract_model.table_name.should == 'players'
    end
  end

  describe "serialization" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
      @controller = RailsAdmin::MainController.new
    end

    it "accepts array value" do
      params = {:array_field => '[1, 3]'}
      @controller.send(:sanitize_params_for!, 'create', @abstract_model.config, params)
      params[:array_field].should == [1, 3]
    end

    it "accepts hash value" do
      params = {:hash_field => '{a: 1, b: 3}'}
      @controller.send(:sanitize_params_for!, 'create', @abstract_model.config, params)
      params[:hash_field].should == {"a"=>1, "b"=>3}
    end
  end
end
