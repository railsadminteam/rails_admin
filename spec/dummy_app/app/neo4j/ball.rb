class Ball
  include Neo4j::ActiveNode
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  property :color, type: String

  validates_presence_of :color, on: :create

  def to_param
    color.present? ? color.downcase.gsub(' ', '-') : id
  end
end
