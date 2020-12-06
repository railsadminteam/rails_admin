class Fan
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  property :name, type: String

  has_and_belongs_to_many :teams

  validates_presence_of(:name)
end
