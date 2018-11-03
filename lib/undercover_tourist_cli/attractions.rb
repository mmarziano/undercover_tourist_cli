require 'undercover_tourist_cli/scraper'

class Attractions 
  attr_accessor :name, :description, :rating, :current_crowd_rating, :priority_attractions
  
  def initialize(name)
    @name = name 
    puts "You have selected #{@name}."
    
  end 
  
end 