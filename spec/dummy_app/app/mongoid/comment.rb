class Comment
  include Mongoid::Document
  field :content, :type => String
  include Mongoid::Timestamps

  attr_accessible :commentable_id, :commentable_type, :content

  belongs_to :commentable, :polymorphic => true
end
