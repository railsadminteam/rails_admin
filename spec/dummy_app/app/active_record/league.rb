class League < ActiveRecord::Base
  has_many :divisions, :foreign_key => 'custom_league_id'
  has_many :teams, ->{ readonly }, :through => :divisions

  validates_presence_of(:name)

  def custom_name
    "League '#{self.name}'"
  end
end
