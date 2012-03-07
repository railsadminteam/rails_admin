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

    it 'list associations types in supported [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]' do
      (@post.associations + @blog.associations + @user.associations).map{|a|a[:type]}.uniq.map(&:to_s).sort.should == ['belongs_to', 'has_and_belongs_to_many', 'has_many', 'has_one']
    end
  end
  
  
  describe '#all' do
    context 'filters on dates' do
      it 'lists elements within outbound limits' do
        date_format = I18n.t("admin.misc.filter_date_format", :default => I18n.t("admin.misc.filter_date_format", :locale => :en)).gsub('dd', '%d').gsub('mm', '%m').gsub('yy', '%Y')
        
        FieldTest.create!(:date_field => Date.strptime("01/01/2012", date_format))
        FieldTest.create!(:date_field => Date.strptime("01/02/2012", date_format))
        FieldTest.create!(:date_field => Date.strptime("01/03/2012", date_format))
        FieldTest.create!(:date_field => Date.strptime("01/04/2012", date_format))
        RailsAdmin.config(FieldTest).abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } ).count.should == 2
        RailsAdmin.config(FieldTest).abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/02/2012"], :o => 'between' } } } ).count.should == 1
        RailsAdmin.config(FieldTest).abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } ).count.should == 2
        RailsAdmin.config(FieldTest).abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } ).count.should == 2
        RailsAdmin.config(FieldTest).abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } ).count.should == 1
        
      end
    end
  end

end
