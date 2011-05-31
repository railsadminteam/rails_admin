class League < ActiveRecord::Base
  validates_presence_of(:name)

  has_many(:divisions)
  has_many(:teams)

  def teams
  	Team.joins(:division).where("divisions.league_id" => id)
  end
  
  def custom_name
    "League '#{self.name}'"
  end
end
