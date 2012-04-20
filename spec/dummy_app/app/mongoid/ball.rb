class Ball
  include Mongoid::Document
  include Mongoid::Timestamps

  field :color, :type => String

  attr_accessible :color

  validates_presence_of :color

  def to_param
    color.present? ? color.downcase.gsub(" ", "-") : id
  end
end
