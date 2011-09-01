class League < ActiveRecord::Base
  validates_presence_of(:name)

  has_many :divisions, :foreign_key => 'custom_league_id'
  has_many :teams, :through => :divisions, :readonly => true

  def custom_name
    "League '#{self.name}'"
  end
end
