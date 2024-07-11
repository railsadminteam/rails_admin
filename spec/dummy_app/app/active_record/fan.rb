

class Fan < ActiveRecord::Base
  has_and_belongs_to_many :teams

  if defined?(CompositePrimaryKeys)
    has_many :fanships, inverse_of: :fan
    has_one :fanship, inverse_of: :fan
  end

  validates_presence_of(:name)
end
