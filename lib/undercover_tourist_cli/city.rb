

class City 
  attr_accessor :name, :city_summary, :attractions, :urls
  
  @@all = []
  
  def initialize(name = nil)
    @name = name.capitalize
    @attractions = []
    @@all << self
  end 
  
  def self.all 
    @@all 
  end 

end 
    