class Case < ActiveRecord::Base
  belongs_to :test, inverse_of: :cases
end
