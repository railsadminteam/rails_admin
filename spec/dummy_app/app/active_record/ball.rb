class Ball < ActiveRecord::Base
  validates_presence_of :color, on: :create

  def to_param
    color.present? ? color.downcase.tr(' ', '-') : id
  end
end
