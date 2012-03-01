class Player < ActiveRecord::Base
  validates_presence_of(:name)
  validates_numericality_of(:number, :only_integer => true)
  validates_uniqueness_of(:number, :scope => :team_id, :message => "There is already a player with that number on this team")

  validates_each :name do |record, attr, value|
    record.errors.add(:base, "Player is cheating") if value.to_s =~ /on steroids/
  end

  belongs_to :team, :inverse_of => :players
  has_one :draft, :dependent => :destroy

  has_many :comments, :as => :commentable
  attr_protected :suspended

  def draft_id
    self.draft.try :id
  end

  def draft_id=(id)
    self.draft = Draft.find_by_id(id)
  end
end
