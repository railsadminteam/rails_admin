class RelTest < ActiveRecord::Base
  validates_numericality_of(:player_id, :only_integer => true)
  belongs_to :league
  belongs_to :division
  belongs_to :player
end
