class Division < ActiveRecord::Base
  set_primary_key :custom_id
  validates_numericality_of(:custom_league_id, :only_integer => true)
  validates_presence_of(:name)

  belongs_to :league, :foreign_key => 'custom_league_id'
  has_many :teams
end
