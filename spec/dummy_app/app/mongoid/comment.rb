class Comment
  include Mongoid::Document
  field :content, :type => String
  include Mongoid::Timestamps

  belongs_to :commentable, :polymorphic => true
end
