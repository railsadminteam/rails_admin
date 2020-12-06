class Division
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  property :name, type: String

  has_one :out, :league, type: :CUSTOM_LEAGUE
  has_many :in, :teams, origin: :division

  validates_presence_of(:custom_league_id)
  validates_presence_of(:name)
end
