class League < ActiveRecord::Base
  validates_presence_of(:name)

  has_many :divisions
  has_many :teams, :through => :divisions, :readonly => true

  def custom_name
    "League '#{self.name}'"
  end
end
