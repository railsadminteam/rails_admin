class Team < ActiveRecord::Base
  validates_numericality_of(:league_id, :only_integer => true)
  validates_numericality_of(:division_id, :only_integer => true)
  validates_presence_of(:manager)
  validates_numericality_of(:founded, :only_integer => true)
  validates_numericality_of(:wins, :only_integer => true)
  validates_numericality_of(:losses, :only_integer => true)
  validates_numericality_of(:win_percentage)
  validates_numericality_of(:revenue, :allow_nil => true)

  belongs_to(:league)
  belongs_to(:division)
  has_many(:players)
  has_and_belongs_to_many :fans
  has_many :comments, :as => :commentable

  def player_names_truncated
    players.map{|p| p.name}.join(", ")[0..32]
  end
end
