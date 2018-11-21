

module UndercoverTouristCli

class Cli 
  
  def call
    puts "---------------------------------"
    puts "Welcome to the Undercover Tourist"
    puts "---------------------------------"
    puts "What city would you like to explore? Type" + " Orlando".colorize(:green) +",  " + "Los Angeles".colorize(:yellow)+ ", " + "San Diego".colorize(:blue)+ ", or" + " Exit".colorize(:red) + " to exit."
    city_selector
  end

  def city_selector 
    input = gets.strip.downcase.split(' ').join('-')
    if input == "orlando" || input == "los-angeles" || input == "san-diego"
      Scraper.city=(input)
      Scraper.scrape_city_summary
      puts "Great choice! Here's some more information on " + Scraper.city.split('-').map {|city| city.capitalize}.join(' ').colorize(:yellow) + 
    ". " + City.city_summary + " Would you like to learn more about this city's attractions? (Y/N)".colorize(:red)
      UndercoverTouristCli::Cli.choice
    elsif input == "exit"
      puts "Exiting."
      exit
    else 
      puts "Entry not recognized. Please check spelling and try again."
      city_selector
   end 
    
  end 
  
  def self.choice
    choice = gets.strip.downcase
      if choice == "Y" || choice == "y"
        UndercoverTouristCli::Cli.pick_attraction
      else 
        UndercoverTouristCli::Cli.new.call
      end
  end 
  
  def self.pick_attraction
    puts "Gathering information..."
    Scraper.scrape_city_attractions
    puts "-------------------------------"
    puts "Below is a list of attractions:"
    puts "-------------------------------"
          i = 1
          Attractions.all.each do |attraction|
            puts "#{i}.".colorize(:red) + " #{attraction.name}".colorize(:blue)
            i += 1
          end 
        puts "Please select a number from the list above."
        Scraper.select_attraction
  end 
  
  def self.pick_attraction_repeat
    choice = gets.strip.downcase
    if choice == "Y" || choice == "y"
      puts "-------------------------------"
      puts "Below is a list of attractions:"
      puts "-------------------------------"
            i = 1
            Attractions.all.name each do |attraction|
              puts "#{i}.".colorize(:red) + " #{attraction.name}".colorize(:blue)
              i += 1
            end 
          puts "Please select a number from the list above."
          Scraper.select_attraction
    else 
      puts "Happy travels!"
      exit
    end
  end 
  
    def self.results
      puts "Attraction Name: ".colorize(:red) 
      puts "Attraction Description: ".colorize(:red) + Attractions.description
      puts "Attraction Rating: ".colorize(:red) + Attractions.rating 
      puts "Today's Attraction Crowd Size (Scale 1-10): ".colorize(:red) + Attractions.current_crowd_rating
      puts "Today's Attraction Hours: ".colorize(:red) + Attractions.hours 
      puts "Be sure to check out: ".colorize(:red) 
        if Attractions.priority_attractions == "N/A"
          puts "N/A"
        else 
          Attractions.priority_attractions.each do |attraction|
            puts attraction
          end 
        end
      puts "Would you like to check out another attraction? (Y/N)".colorize(:cyan)
      UndercoverTouristCli::Cli.pick_attraction_repeat
    end 
  end
end

UndercoverTouristCli::Cli.new.call