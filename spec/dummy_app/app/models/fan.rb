class Fan < ActiveRecord::Base
  validates_presence_of(:name)
  belongs_to :fanable, :polymorphic => true
  has_and_belongs_to_many :teams
end
