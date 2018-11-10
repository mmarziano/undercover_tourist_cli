

class Attractions 
  attr_accessor :name, :description, :rating, :current_crowd_rating, :priority_attractions, :selected_attraction, :city_summary, :hours
  
  def initialize(name)
    @name = name
    puts "You have selected #{@name}."   
    
  end 
  
  
end 