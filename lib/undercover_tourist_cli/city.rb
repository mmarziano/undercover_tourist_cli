

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

  def find_by_name(name)
    self.all.select {|a| a.name == name}
  end 
  
end 
    