

class League
  include Mongoid::Document

  field :name, type: String
  include Mongoid::Timestamps

  has_many :divisions, foreign_key: 'custom_league_id'

  validates_presence_of(:name)

  def custom_name
    "League '#{name}'"
  end
end
