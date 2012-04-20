class Fan < ActiveRecord::Base
  attr_accessible :name, :team_ids

  has_and_belongs_to_many :teams

  validates_presence_of(:name)
end
