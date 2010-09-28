class Fan < ActiveRecord::Base
  validates_presence_of(:name)
  has_and_belongs_to_many :teams
  
  RailsAdmin.config self do
    label "Fans and friends"
    label_for_navigation do
      "#{config.label} Tab"
    end
  end
end
