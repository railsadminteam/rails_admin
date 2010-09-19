class Team < ActiveRecord::Base
  validates_numericality_of(:league_id, :only_integer => true)
  validates_numericality_of(:division_id, :only_integer => true)
  validates_presence_of(:manager)
  validates_numericality_of(:founded, :only_integer => true)
  validates_numericality_of(:wins, :only_integer => true)
  validates_numericality_of(:losses, :only_integer => true)
  validates_numericality_of(:win_percentage)

  belongs_to(:league)
  belongs_to(:division)
  has_many(:players)
  has_and_belongs_to_many :fans
end
