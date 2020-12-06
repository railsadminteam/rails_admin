module Cms
  class BasicPage
    include Neo4j::ActiveNode
    property :title, type: String
    property :content, type: String

    property :created_at, type: DateTime
    property :updated_at, type: DateTime

    validates :title, :content, presence: true
  end
end
