class Cms::BasicPage < ActiveRecord::Base

  validates :title, :content, :presence => true

end
