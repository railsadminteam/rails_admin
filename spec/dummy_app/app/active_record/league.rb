

class League < ActiveRecord::Base
  has_many :divisions, foreign_key: 'custom_league_id'
  has_many :teams, -> { readonly }, through: :divisions
  has_many :players, through: :teams
  has_one :division, foreign_key: 'custom_league_id'

  validates_presence_of(:name)

  def custom_name
    "League '#{name}'"
  end
end
