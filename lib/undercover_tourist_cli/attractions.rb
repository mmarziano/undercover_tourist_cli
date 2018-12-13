

class Attractions 
  attr_accessor :name, :description, :rating, :current_crowd_rating, :priority_attractions, :hours, :list, :city, :url
  
  @@all = []
  
  def initialize(name = nil, description = nil, rating = nil, current_crowd_rating = nil, priority_attractions = nil, hours = nil, url = nil, city = nil)
    @name = name
    @description = description
    @rating = rating
    @current_crowd_rating = current_crowd_rating
    @priority_attractions = priority_attractions
    @hours = hours
    @city = city
    @url = url
    @@all << self
  end 
  
  def self.all
    @@all 
  end 
  
  def self.name=(name)
    @name = name
  end 
  
  def find_by_city(city)
    self.all.select {|a| a.city == city}
  end
  
  def self.name 
    @name
  end 
  
  def self.save(name)
     @@attractions_list << name unless @@attractions_list.include?(name)
  end 
  
  def self.list
    @@attractions_list
  end  
  
  
  def self.rating=(rating)
    @rating = rating
  end 
  
  def self.rating
    @rating
  end
  
  def self.description=(description)
    @description = description
  end 
  
  def self.description
    @description
  end
  
  def self.current_crowd_rating=(rating)
    @current_crowd_rating = rating
  end 
  
  def self.current_crowd_rating
    @current_crowd_rating
  end
  
  def self.hours=(hours)
    @hours = hours
  end 
  
  def self.hours
    @hours
  end
  
  def self.priority_attractions=(attractions)
    @priority_attractions = attractions
  end 
  
  def self.priority_attractions
    @priority_attractions
  end
  
  def self.clear
      @@all.clear
  end 
  
end 