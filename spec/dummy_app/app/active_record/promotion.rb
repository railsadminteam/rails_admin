class Promotion < ActiveRecord::Base
  has_many :promotion_participations
end
