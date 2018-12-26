
class UndercoverTouristCli::CLI 
  
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
              if City.find_by_name(input) 
                city = City.find_by_name(input)
              else 
                city = City.new(input)
              end
          else 
            puts "Invalid entry. Please try again."
            city_selector
          end 
          Scraper.scrape_city_summary(city) if city.city_summary == nil
          puts "Great choice! Here's some more information on " + city.name.colorize(:yellow) + ". " + city.city_summary + " Would you like to learn more about this city's attractions? (Y/N)".colorize(:red)
            choice = gets.strip.downcase
              if choice == "Y" || choice == "y"
                attraction_list(city)
              else 
                exit
              end
      end 

      def attraction_list(city)
        puts "Gathering information..."
        Scraper.scrape_city_attractions(city) if city.attractions.empty?
        puts "-------------------------------"
        puts "Below is a list of attractions:"
        puts "-------------------------------"
          i = 1
          city.attractions.each do |attraction|
              puts "#{i}.".colorize(:red) + " #{attraction.name}".colorize(:blue)
              i += 1
          end 
        puts "Please select a number from the list above."
        select_attraction(city)
      end 
  
      def select_attraction(city)
        input = gets.strip.to_i 
          if input > Attractions.all.count || input < 0 
            puts "Invalid entry. Please try again."
            select_attraction(city)
          end 
        selected_attraction = city.attractions[input - 1]
        puts "Gathering details for #{selected_attraction.name}..."
          if Attractions.find_by_name(selected_attraction) == nil 
            Scraper.attraction_details(Attractions.find_by_name(selected_attraction.name), city)
          end
        results(Attractions.find_by_name(selected_attraction.name), city)
      end
  
  
      def pick_attraction_repeat(city)
        choice = gets.strip.downcase
        case choice 
          when "y"
          puts "-------------------------------"
          puts "Below is a list of attractions:"
          puts "-------------------------------"
                i = 1
                city.attractions.each do |attraction|
                  puts "#{i}.".colorize(:red) + " #{attraction.name}".colorize(:blue)
                  i += 1
                end 
              puts "Please select a number from the list above."
              select_attraction(city)
          when "n"
            puts "Would you like to explore another city (Y/N)?"
              input = gets.strip.downcase
              case input 
                when "y"
                  call
                when "n"
                  exit 
                else
                  puts "Invalid entry.  Please type Y for yes or N for no."
                  pick_attraction_repeat(city)
                end 
            else 
              puts "Invalid entry.  Please type Y for yes or N for no."
              pick_attraction_repeat(city)
          end
        end
    
      def results(attraction, city)
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
        pick_attraction_repeat(city)
        exit
    end
end
