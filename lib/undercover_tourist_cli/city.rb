

class City 
  attr_accessor :name, :city_summary, :attractions 
  
  @@all = []
  
  def initialize(name = nil)
    @name = name.capitalize
    @attractions = []
    @@all << self
  end 
  
  def self.all 
    puts @@all 
  end 

end 
    