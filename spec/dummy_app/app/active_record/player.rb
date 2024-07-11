

class Player < ActiveRecord::Base
  belongs_to :team, optional: true, inverse_of: :players
  has_one :draft, dependent: :destroy
  has_many :comments, as: :commentable

  validates_presence_of(:name)
  validates_numericality_of(:number, only_integer: true)
  validates_uniqueness_of(:number, scope: :team_id, message: 'There is already a player with that number on this team')
  validates_each :name do |record, _attr, value|
    record.errors.add(:base, 'Player is cheating') if /on steroids/.match?(value.to_s)
  end

  enum formation: {start: 'start', substitute: 'substitute'}

  before_destroy :destroy_hook

  scope :rails_admin_search, ->(query) { where(name: query.reverse) }

  def destroy_hook; end
end
