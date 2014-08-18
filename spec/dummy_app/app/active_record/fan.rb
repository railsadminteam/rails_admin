class Fan < ActiveRecord::Base
  has_and_belongs_to_many :teams

  validates_presence_of(:name)
end
