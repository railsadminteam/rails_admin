require 'spec_helper'
require 'rails_admin/adapters/mongoid/abstract_object'

describe "Mongoid::AbstractObject" do
  before(:each) do
    @articles = FactoryGirl.create_list :article, 3
    @author = RailsAdmin::Adapters::Mongoid::AbstractObject.new FactoryGirl.create :author
  end

  describe "references_many association" do
    it "supports retrieval of ids through foo_ids" do
      @author.article_ids.should == []
      article = FactoryGirl.create :article, :author => @author
      @author.article_ids.should == [article.id]
    end

    it "supports assignment of items through foo_ids=" do
      @author.articles.should == []
      @author.article_ids = @articles.map(&:id)
      @author.reload
      @author.articles.sort.should == @articles.sort
    end

    it "skips invalid id on assignment through foo_ids=" do
      @author.article_ids = @articles.map{|item| item.id.to_s }.unshift('4f431021dcf2310db7000006')
      @author.reload
      @author.articles.sort.should == @articles.sort
    end
  end
end
