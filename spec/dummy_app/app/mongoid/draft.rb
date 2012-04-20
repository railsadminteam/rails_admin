class Draft
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :player
  belongs_to :team
  field :date, :type => Date
  field :round, :type => Integer
  field :pick, :type => Integer
  field :overall, :type => Integer
  field :college, :type => String
  field :notes, :type => String

  attr_accessible :player_id, :team_id, :date, :round, :pick, :overall, :college, :notes

  validates_presence_of(:player_id, :only_integer => true)
  validates_presence_of(:team_id, :only_integer => true)
  validates_presence_of(:date)
  validates_numericality_of(:round, :only_integer => true)
  validates_numericality_of(:pick, :only_integer => true)
  validates_numericality_of(:overall, :only_integer => true)
end
