

class UndercoverTouristCli::Cli 
  
  def call
    puts "---------------------------------"
    puts "Welcome to the Undercover Tourist"
    puts "---------------------------------"
    puts "What city would you like to explore? Type" + " Orlando".colorize(:green) +",  " + "Los Angeles".colorize(:yellow)+ ", " + "San Diego".colorize(:blue)+ ", or" + " Exit".colorize(:red) + " to exit."
    city_selector
  end

  def city_selector 
    input = gets.strip.downcase.split(' ').join('-')
    city = City.new(input)
    Scraper.scrape_city_summary(city)
    puts "Great choice! Here's some more information on " + city.name.colorize(:yellow) + ". " + city.city_summary + " Would you like to learn more about this city's attractions? (Y/N)".colorize(:red)
    choice = gets.strip.downcase
      if choice == "Y" || choice == "y"
        pick_attraction(city)
      else 
        call
      end
  end 

  
  def pick_attraction(city)
    puts "Gathering information..."
    #don't scrpae if done
    Scraper.scrape_city_attractions(city)
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
        results
  end 
  
  def pick_attraction_repeat
    choice = gets.strip.downcase
    if choice == "Y" || choice == "y"
      puts "-------------------------------"
      puts "Below is a list of attractions:"
      puts "-------------------------------"
            i = 1
            Scraper.attractions.each do |attraction|
              puts "#{i}.".colorize(:red) + " #{attraction}".colorize(:blue)
              i += 1
            end 
          puts "Please select a number from the list above."
          Scraper.select_attraction
          results
    else 
      puts "Happy travels!"
      exit
    end
  end 
  
    def results
      puts "---------------------------------------------------".colorize(:red)
      puts "***#{Attractions.name}***"
      puts "---------------------------------------------------".colorize(:red)
      puts ""
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
      pick_attraction_repeat
  end
end
