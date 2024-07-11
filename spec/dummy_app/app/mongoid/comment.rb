

class Comment
  include Mongoid::Document
  field :content, type: String
  include Mongoid::Timestamps
  include Taggable

  belongs_to :commentable, polymorphic: true
end
