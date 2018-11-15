

class City 
  attr_accessor :city, :city_summary 
  
  @@all = []
  
  def initialize(city = nil, city_summary = nil)
    @city = city 
    @city_summary = city_summary
    @@all << self
  end 
  
  def self.city 
    @city
  end 
  
  def self.all 
    puts @@all 
  end 
  
  binding.pry
end 
    