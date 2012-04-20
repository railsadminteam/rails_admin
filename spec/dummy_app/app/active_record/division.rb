class Division < ActiveRecord::Base
  if Rails.version < '3.2'
    set_primary_key :custom_id
  else
    self.primary_key = :custom_id
  end

  attr_accessible :name, :league, :custom_league_id, :team_ids

  belongs_to :league, :foreign_key => 'custom_league_id'
  has_many :teams

  validates_numericality_of(:custom_league_id, :only_integer => true)
  validates_presence_of(:name)
end
