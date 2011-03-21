class Player < ActiveRecord::Base
  validates_presence_of(:name)
  validates_numericality_of(:number, :only_integer => true)
  validates_uniqueness_of(:number, :scope => :team_id, :message => "There is already a player with that number on this team")

  belongs_to(:team)
  has_one(:draft)
  has_many :comments, :as => :commentable

  attr_protected :suspended
end
