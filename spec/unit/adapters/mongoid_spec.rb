require 'spec_helper'
require 'rails_admin/adapters/mongoid'

describe RailsAdmin::Adapters::Mongoid do

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

  describe '#associations' do
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
end
