class League < ActiveRecord::Base
  attr_accessible :name, :division_ids, :team_ids, :created_at

  has_many :divisions, :foreign_key => 'custom_league_id'
  has_many :teams, :through => :divisions, :readonly => true

  validates_presence_of(:name)

  def custom_name
    "League '#{self.name}'"
  end
end
