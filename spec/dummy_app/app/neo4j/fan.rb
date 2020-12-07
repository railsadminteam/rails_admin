class Fan
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  property :name, type: String

  has_many :out, :teams, type: :fan_of

  validates_presence_of(:name)
end
