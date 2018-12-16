

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
        attraction_list(city)
      else 
        call
      end
  end 

  
  def attraction_list(city)
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
        select_attraction
        results
  end 
  
  def select_attraction 
    input = gets.strip.to_i 
      if input > Attractions.all.size || input < 0
        puts "Invalid entry. Please try again."
        select_attraction
      end 
      Attractions.all.select.with_index do |val, index|
        if input == index.to_i + 1
          @selected_attraction = val
        end
      end 
    puts "Gathering details for #{@selected_attraction.name}..."
    Scraper.attraction_details(@selected_attraction)
    
    results(@selected_attraction)
  end
  
  
  def pick_attraction_repeat
    choice = gets.strip.downcase
    if choice == "Y" || choice == "y"
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
    else 
      puts "Happy travels!"
      exit
    end
  end 
  
    def results(attraction)
      binding.pry
      puts "---------------------------------------------------".colorize(:red)
      puts "***#{attraction.name}***"
      puts "---------------------------------------------------".colorize(:red)
      puts ""
      puts "Attraction Description: ".colorize(:red) + attraction.description
      puts "Attraction Rating: ".colorize(:red) + attraction.rating 
      puts "Today's Attraction Crowd Size (Scale 1-10): ".colorize(:red) + attraction.current_crowd_rating
      puts "Today's Attraction Hours: ".colorize(:red) + attraction.hours 
      puts "Be sure to check out: ".colorize(:red) 
        if attraction.priority_attractions == "N/A"
          puts "N/A"
        else 
          attraction.priority_attractions.each do |attraction|
            puts attraction
          end 
        end
      puts "Would you like to check out another attraction? (Y/N)".colorize(:cyan)
      #pick_attraction_repeat
      exit
  end
end
