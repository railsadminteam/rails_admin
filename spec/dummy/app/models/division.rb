class Division < ActiveRecord::Base
  validates_numericality_of(:league_id, :only_integer => true)
  validates_presence_of(:name)

  belongs_to(:league)
  has_many(:teams)
end
