require 'spec_helper'
require 'rails_admin/adapters/active_record'


describe RailsAdmin::Adapters::ActiveRecord do

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

  describe '#associations' do
    it 'lists associations' do
      @post.associations.map{|a|a[:name].to_s}.sort.should == ['a_r_blog', 'a_r_categories', 'a_r_comments']
    end

    it 'list associations types in supported [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]' do
      (@post.associations + @blog.associations + @user.associations).map{|a|a[:type]}.uniq.map(&:to_s).sort.should == ['belongs_to', 'has_and_belongs_to_many', 'has_many', 'has_one']
    end

    it "has correct parameter of belongs_to association" do
      param = @post.associations.select{|a| a[:name] == :a_r_blog}.first
      param.reject{|k, v| [:child_model_proc, :parent_model_proc].include? k }.should == {
        :name=>:a_r_blog,
        :pretty_name=>"A r blog",
        :type=>:belongs_to,
        :parent_key=>[:id],
        :child_key=>:a_r_blog_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>nil,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:child_model_proc].call.should == ARPost
      param[:parent_model_proc].call.should == ARBlog
    end

    it "has correct parameter of has_many association" do
      param = @blog.associations.select{|a| a[:name] == :a_r_posts}.first
      param.reject{|k, v| [:child_model_proc, :parent_model_proc].include? k }.should == {
        :name=>:a_r_posts,
        :pretty_name=>"A r posts",
        :type=>:has_many,
        :parent_key=>[:id],
        :child_key=>:ar_blog_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>nil,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:child_model_proc].call.should == ARPost
      param[:parent_model_proc].call.should == ARBlog
    end

    it "has correct parameter of has_and_belongs_to_many association" do
      param = @post.associations.select{|a| a[:name] == :a_r_categories}.first
      param.reject{|k, v| [:child_model_proc, :parent_model_proc].include? k }.should == {
        :name=>:a_r_categories,
        :pretty_name=>"A r categories",
        :type=>:has_and_belongs_to_many,
        :parent_key=>[:id],
        :child_key=>:ar_post_id,
        :foreign_type=>nil,
        :as=>nil,
        :polymorphic=>nil,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:child_model_proc].call.should == ARCategory
      param[:parent_model_proc].call.should == ARPost
    end

    it "has correct parameter of polymorphic belongs_to association" do
      RailsAdmin::Config.stub!(:models_pool).and_return(["ARBlog", "ARPost", "ARCategory", "ARUser", "ARProfile", "ARComment"])
      param = @comment.associations.select{|a| a[:name] == :commentable}.first
      param.reject{|k, v| [:child_model_proc, :parent_model_proc].include? k }.should == {
        :name=>:commentable,
        :pretty_name=>"Commentable",
        :type=>:belongs_to,
        :parent_key=>[:id],
        :child_key=>:commentable_id,
        :foreign_type=>:commentable_type,
        :as=>nil,
        :polymorphic=>true,
        :inverse_of=>nil,
        :read_only=>nil,
        :nested_form=>nil
      }
      param[:child_model_proc].call.should == ARComment
      param[:parent_model_proc].call.should == [ARBlog, ARPost]
    end
  end
end
