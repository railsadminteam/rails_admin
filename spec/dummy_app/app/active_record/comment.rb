

class Comment < ActiveRecord::Base
  include Taggable
  belongs_to :commentable, polymorphic: true, optional: true
end
