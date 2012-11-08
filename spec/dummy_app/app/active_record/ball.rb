class Ball < ActiveRecord::Base
  attr_accessible :color

  validates_presence_of :color, :on => :create

  def to_param
    color.present? ? color.downcase.gsub(" ", "-") : id
  end
end
