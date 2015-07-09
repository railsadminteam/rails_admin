class Player
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  include ActiveModel::ForbiddenAttributesProtection

  property :deleted_at, type: DateTime
  has_one :out, :team, type: :PLAYS_FOR
  property :name, type: String
  property :position, type: String
  property :number, type: Integer
  property :retired, type: Boolean, default: false
  property :injured, type: Boolean, default: false
  property :born_on, type: Date
  property :notes, type: String
  property :suspended, type: Boolean, default: false

  validates_presence_of(:name)
  validates_numericality_of(:number, only_integer: true)
  validates_uniqueness_of(:number, scope: :team_id, message: 'There is already a player with that number on this team')

  validates_each :name do |record, _attr, value|
    record.errors.add(:base, 'Player is cheating') if value.to_s =~ /on steroids/
  end

  has_one :draft, dependent: :destroy
  has_many :comments, as: :commentable

  before_destroy :destroy_hook

  def destroy_hook; end

  def draft_id
    draft.try :id
  end

  def draft_id=(id)
    self.draft = Draft.where(_id: id).first
  end
end
