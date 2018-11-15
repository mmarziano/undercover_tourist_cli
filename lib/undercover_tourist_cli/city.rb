#require_relative "../undercover_tourist_cli"

class City 
  attr_accessor :city 
  
  def initialize(city)
    @city = city 
  end 
  
  def self.city 
    @city
  end 
  
end 
    