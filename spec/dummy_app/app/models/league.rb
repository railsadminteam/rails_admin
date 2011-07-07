class League < ActiveRecord::Base
  validates_presence_of(:name)

  has_many :divisions
  has_many :teams, :through => :divisions

  def custom_name
    "League '#{self.name}'"
  end
end
