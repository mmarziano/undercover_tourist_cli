
class Attractions 
  attr_accessor :name, :description, :rating, :current_crowd_rating, :priority_attractions, :hours, :list, :city, :url
  
  @@all = []
  
  def initialize(name = nil, description = nil, rating = nil, current_crowd_rating = nil, priority_attractions = nil, hours = nil, url = nil, city = nil)
    @name = name
    @description = description
    @rating = rating
    @current_crowd_rating = current_crowd_rating
    @priority_attractions = []
    @hours = hours
    @city = city
    @url = url
    @@all << self
  end 
  
  def self.all
    @@all 
  end 
  
  def find_by_city(city)
    self.all.select {|a| a.city == city}
  end
  
  def self.find_by_name(name)
    @@all.detect {|a| a.name == name}
  end
  
  
end 