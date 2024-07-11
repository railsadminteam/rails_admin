

class Ball < ActiveRecord::Base
  has_one :comment, as: :commentable

  validates_presence_of :color, on: :create

  def to_param
    color.present? ? color.downcase.tr(' ', '-') : id
  end
end
