class Player
  include Mongoid::Document
  include Mongoid::Timestamps

  field :deleted_at, :type => DateTime
  belongs_to :team, :inverse_of => :players
  field :name, :type => String
  field :position, :type => String
  field :number, :type => Integer
  field :retired, :type => Boolean, :default => false
  field :injured, :type => Boolean, :default => false
  field :born_on, :type => Date
  field :notes, :type => String
  field :suspended, :type => Boolean, :default => false

  attr_accessible :name, :team_id, :position, :number, :retired, :injured, :born_on, :notes, :comment_ids, :created_at
  attr_protected :suspended

  validates_presence_of(:name)
  validates_numericality_of(:number, :only_integer => true)
  validates_uniqueness_of(:number, :scope => :team_id, :message => "There is already a player with that number on this team")

  validates_each :name do |record, attr, value|
    record.errors.add(:base, "Player is cheating") if value.to_s =~ /on steroids/
  end

  has_one :draft, :dependent => :destroy
  has_many :comments, :as => :commentable

  before_destroy :destroy_hook

  def destroy_hook; end

  def draft_id
    self.draft.try :id
  end

  def draft_id=(id)
    self.draft = Draft.where(:_id => id).first
  end
end
