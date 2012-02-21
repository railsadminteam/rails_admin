require 'spec_helper'
require 'rails_admin/adapters/active_record'


describe RailsAdmin::Adapters::ActiveRecord do
  
  before :all do
    
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
  
  describe '#associations' do
    it 'lists associations' do
      @post.associations.map{|a|a[:name].to_s}.sort.should == ['a_r_blog', 'a_r_categories', 'a_r_comments']
    end
    
    it 'reads correct and know types in [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]' do
      (@post.associations + @blog.associations + @user.associations).map{|a|a[:type]}.uniq.map(&:to_s).sort.should == ['belongs_to', 'has_and_belongs_to_many', 'has_many', 'has_one']
    end
  end
end