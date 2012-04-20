class Division
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  attr_accessible :name, :league, :custom_league_id, :team_ids

  belongs_to :league, :foreign_key => 'custom_league_id'
  has_many :teams

  validates_presence_of(:custom_league_id)
  validates_presence_of(:name)
end
