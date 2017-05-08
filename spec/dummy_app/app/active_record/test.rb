class Test < ActiveRecord::Base
  has_many :cases, inverse_of: :test
end
