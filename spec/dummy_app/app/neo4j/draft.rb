class Draft
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  has_one :out, :player, type: :draft_for
  has_one :out, :team, type: :picked_for
  property :date, type: Date
  property :round, type: Integer
  property :pick, type: Integer
  property :overall, type: Integer
  property :college, type: String
  property :notes, type: String

  validates_presence_of(:player_id, only_integer: true)
  validates_presence_of(:team_id, only_integer: true)
  validates_presence_of(:date)
  validates_numericality_of(:round, only_integer: true)
  validates_numericality_of(:pick, only_integer: true)
  validates_numericality_of(:overall, only_integer: true)
end
