class League
  include Mongoid::Document

  field :name, :type => String
  include Mongoid::Timestamps

  attr_accessible :name, :division_ids, :team_ids, :created_at

  has_many :divisions, :foreign_key => 'custom_league_id'

  validates_presence_of(:name)

  def custom_name
    "League '#{self.name}'"
  end
end
