class History < ActiveRecord::Base
  
  def self.latest
    mstart = 5.month.ago.month
    mstop = Time.now.month
    
    ystop = Time.now.year
    ystart = 5.month.ago.year
    
    self.get_history_for_dates(mstart,mstop,ystart,ystop)
  end
  
  def self.get_history_for_dates(mstart,mstop,ystart,ystop)
    History.find_by_sql("select count(*) as number, year, month from histories where month between #{mstart} and #{mstop} and year between #{ystart} and #{ystop} group by year, month")
  end
end
