
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
  
  def self.find_by_name(name)
    @@all.detect {|a| a.name.downcase == name.downcase}
  end
  
end 
    