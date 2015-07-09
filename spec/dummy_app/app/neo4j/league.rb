class League
  include Neo4j::ActiveNode

  property :name, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  has_many :in, :divisions, type: 'CUSTOM_LEAGUE'

  validates_presence_of(:name)

  def custom_name
    "League '#{name}'"
  end
end
