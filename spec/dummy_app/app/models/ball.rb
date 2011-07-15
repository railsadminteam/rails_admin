class Ball < ActiveRecord::Base

  validates_presence_of :color

  def to_param
    color.present? ? color.downcase.gsub(" ", "-") : id
  end
end
