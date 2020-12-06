# coding: utf-8

class Team
  include Neo4j::ActiveNode
  
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  has_one :out, :division, type: :BELONGS_TO_DIVISION

  property :name, type: String
  property :logo_url, type: String
  property :manager, type: String
  property :ballpark, type: String
  property :mascot, type: String
  property :founded, type: Integer
  property :wins, type: Integer
  property :losses, type: Integer
  property :win_percentage, type: Float
  property :revenue, type: BigDecimal
  property :color, type: String
  property :custom_field, type: String

  has_many :in, :players, origin: :team#, order: :_id.asc
  #has_and_belongs_to_many :fans
  has_many :in, :comments, origin: :commentable

  validates_presence_of :division_id, only_integer: true
  validates_presence_of :manager
  validates_numericality_of :founded, only_integer: true
  validates_numericality_of :wins, only_integer: true
  validates_numericality_of :losses, only_integer: true
  validates_numericality_of :win_percentage
  validates_numericality_of :revenue, allow_nil: true
  # needed to force these attributes to :string type
  validates_length_of :logo_url, maximum: 255
  validates_length_of :manager, maximum: 100
  validates_length_of :ballpark, maximum: 100
  validates_length_of :mascot, maximum: 100

  def player_names_truncated
    players.collect(&:name).join(', ')[0..32]
  end

  def color_enum
    ['white', 'black', 'red', 'green', 'blu<e>é']
  end

  scope :green, -> { where(color: 'red') }
  scope :red, -> { where(color: 'red') }
  scope :white, -> { where(color: 'white') }
end
