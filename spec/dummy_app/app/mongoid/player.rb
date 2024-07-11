

class Player
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::ForbiddenAttributesProtection

  field :deleted_at, type: DateTime
  belongs_to :team, inverse_of: :players
  field :name, type: String
  field :position, type: String
  field :number, type: Integer
  field :retired, type: Boolean, default: false
  field :injured, type: Boolean, default: false
  field :born_on, type: Date
  field :notes, type: String
  field :suspended, type: Boolean, default: false
  field :formation, type: String

  validates_presence_of(:name)
  validates_numericality_of(:number, only_integer: true)
  validates_uniqueness_of(:number, scope: :team_id, message: 'There is already a player with that number on this team')

  validates_each :name do |record, _attr, value|
    record.errors.add(:base, 'Player is cheating') if /on steroids/.match?(value.to_s)
  end

  has_one :draft, dependent: :destroy
  has_many :comments, as: :commentable

  before_destroy :destroy_hook

  scope :rails_admin_search, ->(query) { where(name: query.reverse) }

  def destroy_hook; end
end
