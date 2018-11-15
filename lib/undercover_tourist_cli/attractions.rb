

class Attractions 
  attr_accessor :name, :description, :rating, :current_crowd_rating, :priority_attractions, :selected_attraction, :city_summary, :hours
  
  @@all = []
  
  def initialize(name = nil, description = nil, rating = nil, current_crowd_rating = nil, priority_attractions = nil, selected_attraction = nil, hours = nil)
    @name = name
    @description = description
    @rating = rating
    @current_crowd_rating = current_crowd_rating
    @priority_attractions = priority_attractions
    @selected_attractions = selected_attractions
    @hours = hours
    @@all << self
    
    puts "You have selected #{@name}."   
  end 
  
  def attractions 
    @@all 
  end 
  
  def self.name 
    @name
  end 
  
  def self.save
    @@all << @name 
  end 
  
end 