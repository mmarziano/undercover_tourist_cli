

class City 
  attr_accessor :name, :city_summary 
  
  @@all = []
  
  def initialize(name = nil, city_summary = nil)
    @name = name 
    @city_summary = city_summary
    @@all << self
  end 
  
  def self.name 
    @name
  end 
  
  def self.city_summary=(summary)
    @city_summary = summary
  end 
  
  def self.city_summary
    @city_summary
  end 
  
  def self.all 
    puts @@all 
  end 

end 
    