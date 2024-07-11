

class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :division
  field :name, type: String
  field :logo_url, type: String
  field :manager, type: String
  field :ballpark, type: String
  field :mascot, type: String
  field :founded, type: Integer
  field :wins, type: Integer
  field :losses, type: Integer
  field :win_percentage, type: Float
  field :revenue, type: BigDecimal
  field :color, type: String
  field :custom_field, type: String
  field :main_sponsor, type: Integer

  has_many :players, inverse_of: :team, order: :_id.asc
  has_and_belongs_to_many :fans
  has_many :comments, as: :commentable

  validates_presence_of :division_id, only_integer: true
  validates_presence_of :manager
  validates_numericality_of :founded, only_integer: true, allow_blank: true
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
