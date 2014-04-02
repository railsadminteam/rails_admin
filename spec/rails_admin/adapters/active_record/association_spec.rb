require 'spec_helper'
require 'timecop'

describe 'RailsAdmin::Adapters::ActiveRecord::Association', active_record: true do
  before :all do
    RailsAdmin::AbstractModel.reset_polymorphic_parents

    class ARBlog < ActiveRecord::Base
      has_many :a_r_posts
      has_many :a_r_comments, as: :commentable
      belongs_to :librarian, polymorphic: true
    end

    class ARPost < ActiveRecord::Base
      belongs_to :a_r_blog
      has_and_belongs_to_many :a_r_categories
      has_many :a_r_comments, as: :commentable
    end

    class ARCategory < ActiveRecord::Base
      has_and_belongs_to_many :a_r_posts
      belongs_to :librarian, polymorphic: true
    end

    class ARUser < ActiveRecord::Base
      has_one :a_r_profile
      has_many :a_r_categories, as: :librarian
    end

    class ARProfile < ActiveRecord::Base
      belongs_to :a_r_user
      has_many :a_r_blogs, as: :librarian
    end

    class ARComment < ActiveRecord::Base
      belongs_to :commentable, polymorphic: true
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
    expect(@post.associations.collect { |a|a.name.to_s }).to include(*%w[a_r_blog a_r_categories a_r_comments])
  end

  it 'list associations types in supported [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]' do
    # ActiveRecord 4.1 converts has_and_belongs_to_many association to has_many
    expect((@post.associations + @blog.associations + @user.associations).collect { |a| a.type }.uniq.collect(&:to_s)).to include(*%w[belongs_to has_many has_one])
  end

  describe 'belongs_to association' do
    subject { @post.associations.select { |a| a.name == :a_r_blog }.first }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'A r blog'
      expect(subject.type).to eq :belongs_to
      expect(subject.klass).to eq ARBlog
      expect(subject.primary_key).to eq :id
      expect(subject.foreign_key).to eq :a_r_blog_id
      expect(subject.foreign_type).to be_nil
      expect(subject.as).to be_nil
      expect(subject.polymorphic?).to be_false
      expect(subject.inverse_of).to be_nil
      expect(subject.read_only?).to be_false
      expect(subject.nested_options).to be_nil
    end
  end

  describe 'has_many association' do
    subject { @blog.associations.select { |a| a.name == :a_r_posts }.first }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'A r posts'
      expect(subject.type).to eq :has_many
      expect(subject.klass).to eq ARPost
      expect(subject.primary_key).to eq :id
      expect(subject.foreign_key).to eq :ar_blog_id
      expect(subject.foreign_type).to be_nil
      expect(subject.as).to be_nil
      expect(subject.polymorphic?).to be_false
      expect(subject.inverse_of).to be_nil
      expect(subject.read_only?).to be_false
      expect(subject.nested_options).to be_nil
    end
  end

  describe 'has_and_belongs_to_many association' do
    subject { @post.associations.select { |a| a.name == :a_r_categories }.first }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'A r categories'
      expect(subject.klass).to eq ARCategory
      expect(subject.primary_key).to eq :id
      expect(subject.foreign_type).to be_nil
      expect(subject.as).to be_nil
      expect(subject.polymorphic?).to be_false
      expect(subject.inverse_of).to be_nil
      expect(subject.read_only?).to be_false
      expect(subject.nested_options).to be_nil
    end
  end

  describe 'polymorphic belongs_to association' do
    before { allow(RailsAdmin::Config).to receive(:models_pool).and_return(%w[ARBlog ARPost ARCategory ARUser ARProfile ARComment]) }
    subject { @comment.associations.select { |a| a.name == :commentable }.first }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'Commentable'
      expect(subject.type).to eq :belongs_to
      expect(subject.klass).to eq [ARBlog, ARPost]
      expect(subject.primary_key).to be_nil
      expect(subject.foreign_key).to eq :commentable_id
      expect(subject.foreign_type).to eq :commentable_type
      expect(subject.as).to be_nil
      expect(subject.polymorphic?).to be_true
      expect(subject.inverse_of).to be_nil
      expect(subject.read_only?).to be_false
      expect(subject.nested_options).to be_nil
    end

    it 'looks up correct inverse model' do
      expect(@category.associations.detect { |a| a.name == :librarian }.klass).to eq [ARUser]
      expect(@blog.associations.detect { |a| a.name == :librarian }.klass).to eq [ARProfile]
    end
  end

  describe 'polymorphic inverse has_many association' do
    subject { @blog.associations.select { |a| a.name == :a_r_comments }.first }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'A r comments'
      expect(subject.type).to eq :has_many
      expect(subject.klass).to eq ARComment
      expect(subject.primary_key).to eq :id
      expect(subject.foreign_key).to eq :commentable_id
      expect(subject.foreign_type).to be_nil
      expect(subject.as).to eq :commentable
      expect(subject.polymorphic?).to be_false
      expect(subject.inverse_of).to be_nil
      expect(subject.read_only?).to be_false
      expect(subject.nested_options).to be_nil
    end
  end
end
