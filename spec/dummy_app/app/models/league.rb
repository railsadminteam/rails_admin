class League < ActiveRecord::Base
  validates_presence_of(:name)

  has_many(:divisions)
  has_many(:teams)
end
