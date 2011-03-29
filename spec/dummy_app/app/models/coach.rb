class Coach < ActiveRecord::Base
  validates_presence_of(:name)

  def soft_destroy
    update_attribute(:disabled, true)

    @destroyed = true
    freeze
  end
end

