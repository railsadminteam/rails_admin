require 'spec_helper'
require 'timecop'
require 'rails_admin/adapters/mongoid'

describe RailsAdmin::Adapters::Mongoid do
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
      @post.associations.map{|a|a[:name]}.should == [:mongo_blog, :mongo_categories, :mongo_comments]
    end

    it 'reads correct and know types in [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]' do
      (@post.associations + @blog.associations + @user.associations).map{|a|a[:type]}.uniq.sort.should == [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]
    end

    it "has correct parameter of belongs_to association" do
      param = @post.associations.select{|a| a[:name] == :mongo_blog}.first
      param.reject{|k, v| [:child_model_proc, :parent_model_proc].include? k }.should == {
        :name=>:mongo_blog,
        :pretty_name=>"Mongo blog",
        :type=>:belongs_to,
        :parent_key=>[:_id],
        :child_key=>:mongo_blog_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:child_model_proc].call.should == MongoPost
      param[:parent_model_proc].call.should == MongoBlog
    end

    it "has correct parameter of has_many association" do
      param = @blog.associations.select{|a| a[:name] == :mongo_posts}.first
      param.reject{|k, v| [:child_model_proc, :parent_model_proc].include? k }.should == {
        :name=>:mongo_posts,
        :pretty_name=>"Mongo posts",
        :type=>:has_many,
        :parent_key=>[:_id],
        :child_key=>:mongo_blog_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:child_model_proc].call.should == MongoPost
      param[:parent_model_proc].call.should == MongoBlog
    end

    it "has correct parameter of has_and_belongs_to_many association" do
      param = @post.associations.select{|a| a[:name] == :mongo_categories}.first
      param.reject{|k, v| [:child_model_proc, :parent_model_proc].include? k }.should == {
        :name=>:mongo_categories,
        :pretty_name=>"Mongo categories",
        :type=>:has_and_belongs_to_many,
        :parent_key=>[:_id],
        :child_key=>:mongo_category_ids,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>false,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:child_model_proc].call.should == MongoCategory
      param[:parent_model_proc].call.should == MongoPost
    end

    it "has correct parameter of polymorphic belongs_to association" do
      RailsAdmin::Config.stub!(:models_pool).and_return(["MongoBlog", "MongoPost", "MongoCategory", "MongoUser", "MongoProfile", "MongoComment"])
      param = @comment.associations.select{|a| a[:name] == :commentable}.first
      param.reject{|k, v| [:child_model_proc, :parent_model_proc].include? k }.should == {
        :name=>:commentable,
        :pretty_name=>"Commentable",
        :type=>:belongs_to,
        :parent_key=>[:_id],
        :child_key=>:commentable_id,
        :foreign_type=>:commentable_type,
        :as=>nil,
        :polymorphic=>true,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:child_model_proc].call.should == MongoComment
      param[:parent_model_proc].call.should == [MongoBlog, MongoPost]
    end
  end

  describe "#properties" do
    before :all do
      @abstract_model = RailsAdmin::AbstractModel.new(MongoidFieldTest)
    end

    it "maps Mongoid column types to RA types" do
      @abstract_model.properties.sort{|a,b| a[:name] <=> b[:name] }.should == [
        { :name => :_id,
          :pretty_name => "Id",
          :nullable? => true,
          :serial? => false,
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
          :type => :array,
          :length => nil },
        { :name => :big_decimal_field,
          :pretty_name => "Big decimal field",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 1024 },
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
        { :name => :date_time_field,
          :pretty_name => "Date time field",
          :nullable? => true,
          :serial? => false,
          :type => :datetime,
          :length => nil },
        { :name => :description,
          :pretty_name => "Description",
          :nullable? => true,
          :serial? => false,
          :type => :text,
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
          :type => :hash,
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
      @articles = FactoryGirl.create_list(:article, 3)
      @abstract_model = RailsAdmin::AbstractModel.new('Article')
    end

    it "#new returns instance of AbstractObject" do
      @abstract_model.new.object.should be_instance_of(Article)
    end

    it "#get returns instance of AbstractObject" do
      @abstract_model.get(@articles.first.id.to_s).object.should == @articles.first
    end

    it "#get returns nil when id does not exist" do
      @abstract_model.get('4f4f0824dcf2315093000000').should be_nil
    end

    it "#first returns first item" do
      @abstract_model.first.should == @articles.first
    end

    it "#count returns count of items" do
      @abstract_model.count.should == @articles.count
    end

    it "#destroy destroys multiple items" do
      @abstract_model.destroy(@articles[0..1])
      Article.all.should == @articles[2..2]
    end

    describe "#all" do
      it "works without options" do
        @abstract_model.all.sort.should == @articles.sort
      end

      it "supports eager loading" do
        @abstract_model.all(:include => :author).inclusions.map{|i| i.class_name}.should == ["Author"]
      end

      it "supports limiting" do
        @abstract_model.all(:limit => 2).to_a.count.should == 2
      end

      it "supports retrieval by bulk_ids" do
        @abstract_model.all(:bulk_ids => @articles[0..1].map{|article| article.id.to_s }).
          sort.should == @articles[0..1].sort
      end

      it "supports pagination" do
        @abstract_model.all(:page => 2, :per => 1).should == @articles[1..1]
      end

      it "supports ordering" do
        @abstract_model.all(:sort => "id", :sort_reverse => true).should == @articles.sort
      end

      it "supports querying" do
        @abstract_model.all(:query => @articles[1].title).should == @articles[1..1]
      end

      it "supports filtering" do
        @abstract_model.all(:filters => {"title" => {"0000" => {:o=>"is", :v=>@articles[1].title}}}).should == @articles[1..1]
      end
    end
  end

  describe "#query_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Article')
    end

    it "returns query statement" do
      @abstract_model.send(:query_conditions, "word").should ==
        {"$or"=>[{"title"=>/word/}, {"body"=>/word/}]}
    end
  end

  describe "#filter_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Article')
    end

    it "returns filter statement" do
      pending "Alternative for SQL join query should be implemented"
      @abstract_model.send(
        :filter_conditions,
        {"title" => {"0000" => {:o=>"is", :v=>"foo"}},
         "author" => {"0001" => {:o=>"like", :v=>"1"}}}
      ).should == {"$and"=>[{"title"=>"foo"}, {"$or"=>[{"authors.name"=>/1/}, {"author_id"=>"1"}]}]}
    end
  end

  describe "#build_statement" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Article')
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

    [:datetime, :timestamp, :date].each do |type|
      it "supports #{type} query" do
        @abstract_model.send(:build_statement, :field, type, "", "default").should be_nil
        @abstract_model.send(:build_statement, :field, type, "", "is").should be_nil
        Timecop.freeze(Time.utc(2012,1,15,12,0,0)) do
          @abstract_model.send(:build_statement, :field, type, "", "today").to_s.should ==
            '{:field=>{"$gte"=>Sun, 15 Jan 2012 00:00:00 UTC +00:00, "$lte"=>Sun, 15 Jan 2012 23:59:59 UTC +00:00}}'
          @abstract_model.send(:build_statement, :field, type, "", "yesterday").to_s.should ==
            '{:field=>{"$gte"=>Sat, 14 Jan 2012 00:00:00 UTC +00:00, "$lte"=>Sat, 14 Jan 2012 23:59:59 UTC +00:00}}'
          @abstract_model.send(:build_statement, :field, type, "", "this_week").to_s.should ==
            '{:field=>{"$gte"=>Mon, 09 Jan 2012 00:00:00 UTC +00:00, "$lte"=>Sun, 15 Jan 2012 23:59:59 UTC +00:00}}'
          @abstract_model.send(:build_statement, :field, type, "", "last_week").to_s.should ==
            '{:field=>{"$gte"=>Mon, 02 Jan 2012 00:00:00 UTC +00:00, "$lte"=>Sun, 08 Jan 2012 23:59:59 UTC +00:00}}'
          @abstract_model.send(:build_statement, :field, type, "", "less_than").should be_nil
          @abstract_model.send(:build_statement, :field, type, "1", "less_than").to_s.should ==
            '{:field=>{"$gte"=>Sat, 14 Jan 2012 12:00:00 UTC +00:00}}'
          @abstract_model.send(:build_statement, :field, type, "1", "more_than").to_s.should ==
            '{:field=>{"$lte"=>Sat, 14 Jan 2012 12:00:00 UTC +00:00}}'
        end
        @abstract_model.send(:build_statement, :field, type, "", "mmddyyyy").should be_nil
        @abstract_model.send(:build_statement, :field, type, "201105", "mmddyyyy").should be_nil
        @abstract_model.send(:build_statement, :field, type, "12312011", "mmddyyyy").to_s.should ==
          '{:field=>{"$gte"=>Sat, 31 Dec 2011 00:00:00 UTC +00:00, "$lte"=>Sat, 31 Dec 2011 23:59:59 UTC +00:00}}'
      end
    end

    it "supports enum type query" do
      @abstract_model.send(:build_statement, :field, :enum, "1", nil).should == {:field => {"$in" => ["1"]}}
    end
  end

  describe "model attribute method" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Article')
    end

    it "#scoped returns relation object" do
      @abstract_model.scoped.should be_instance_of(Mongoid::Criteria)
    end

    it "#table_name works" do
      @abstract_model.table_name.should == 'articles'
    end

    it "#serialized_attributes works" do
      class MongoUser
        include Mongoid::Document
        field :name, :type => String
        field :array_field, :type => Array
        field :hash_field, :type => Hash
      end

      RailsAdmin::AbstractModel.new('MongoUser').serialized_attributes.keys.should == ["array_field", "hash_field"]
    end
  end
end
