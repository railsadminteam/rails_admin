class Club < ActiveRecord::Base
  validates_presence_of(:name)

  def custom_destroy 
    update_attribute(:disabled, true)

    @destroyed = true
    freeze
  end
end


