class Comment < ActiveRecord::Base
  include Taggable
  belongs_to :commentable, :polymorphic => true
end
