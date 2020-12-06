class Comment
  include Neo4j::ActiveNode

  property :content, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  include Taggable

  has_one :out, :commentable, type: :COMMENTS_ON, model_class: false
end
