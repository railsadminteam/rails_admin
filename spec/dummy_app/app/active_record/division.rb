

class Division < ActiveRecord::Base
  self.primary_key = :custom_id

  belongs_to :league, foreign_key: 'custom_league_id', optional: true
  has_many :teams

  validates_numericality_of(:custom_league_id, only_integer: true)
  validates_presence_of(:name)
end
