class Player < ActiveRecord::Base
  belongs_to :team, inverse_of: :players
  has_one :draft, dependent: :destroy
  has_many :comments, as: :commentable

  validates_presence_of(:name)
  validates_numericality_of(:number, only_integer: true)
  validates_uniqueness_of(:number, scope: :team_id, message: 'There is already a player with that number on this team')
  validates_each :name do |record, _attr, value|
    record.errors.add(:base, 'Player is cheating') if value.to_s =~ /on steroids/
  end

  if ::Rails.version >= '4.1'
    enum formation: {start: 'start', substitute: 'substitute'}
  end

  before_destroy :destroy_hook

  def destroy_hook; end

  def draft_id
    draft.try :id
  end

  def draft_id=(id)
    self.draft = Draft.find_by_id(id)
  end
end
