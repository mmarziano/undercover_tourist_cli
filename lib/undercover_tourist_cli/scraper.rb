require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'
require_relative "attractions"

class Scraper 
  attr_accessor :city, :page, :attractions
  
  @base_path = "https://www.undercovertourist.com"
  @city_attractions = {}
  @attractions = []
  @attraction_urls = []
  
  def self.parse_page
    @page = Nokogiri::HTML(open(@base_path + "/#{@city}"))
    return @page
  end
  
  def self.city_selector
    puts "---------------------------------"
    puts "Welcome to the Undercover Tourist"
    puts "---------------------------------"
    puts "What city would you like to explore? Type 1 for" + " Orlando".colorize(:green) +", 2 for " + "Los Angeles".colorize(:yellow)+ ", 3 for " + "San Diego".colorize(:blue)+ ", or" + " Exit".colorize(:red) + " to exit."
    input = gets.strip.downcase
    case input 
    when input = "1"
      @city = "Orlando"
      puts "You have selected #{@city}."
    when input = "2" 
      @city = "Los-Angeles"
      puts "You have selected #{@city}."
    when input = "3" 
      @city = "San-Diego"
      puts "You have selected #{@city}."
    when input = "Exit".downcase
      @city = nil
      puts "Exiting."
    else 
      puts "Please try again."
      Scraper.city_selector
    end
    Scraper.scrape_city_summary
  end 

  def self.scrape_city_summary
    @city = @city.downcase
    Scraper.parse_page
    @city_attractions[:city_summary] = @page.css(".cityblurb").children.css("p").text
    puts @city_attractions
    Scraper.scrape_city_attractions
  end 
  
  def self.scrape_city_attractions
    @city = @city.downcase
    @page = Nokogiri::HTML(open(@base_path + "/#{@city}" +"/attractions"))
    node = @page.css('.tile .tiletitle')
      node.each do |node|
       @attractions << node.text
      end
    
      
    @city_attractions[:attractions] = @attractions
        puts "-------------------------------"
        puts "Below is a list of attractions:"
        puts "-------------------------------"
        i = 1
          @attractions.each do |attraction|
            puts "#{i}.".colorize(:red) + " #{attraction}".colorize(:blue)
            i += 1
          end 
        puts "Please select a number from the list above."
        Scraper.select_attraction
  end 
  
  def self.select_attraction
    input = gets.strip.to_i
    @attractions.select.with_index do |val, index|
      if input == index.to_i + 1
        @selected_attraction = val
      end
    end 
    @page = Nokogiri::HTML(open(@base_path + "/#{@city}" +"/attractions"))
    node = @page.css('.tile')
    node.each do |node|
       url = node.children.css('a').attribute('href')
       attraction_url = @base_path + "#{url}"
       @attraction_urls << attraction_url
      end 
    @attraction_urls.select.with_index do |val, index|
      if input == index.to_i + 1
        @selected_attraction_url = val
      end
    end
    Attractions.new(@selected_attraction)
    Scraper.scrape_attraction_rating
    Scraper.scrape_attraction_crowdrating
    Scraper.scrape_attraction_description
    Scraper.scrape_attraction_hours
    Scraper.scrape_priority_attractions
  end
  
  
  def self.scrape_attraction_rating
    @page = Nokogiri::HTML(open(@selected_attraction_url))
    node1 = @page.css('.reviewpads')
    if node1.empty?
      @city_attractions[:rating] = "N/A"
        puts "Attraction Rating Unavailable"
    else
     node = @page.css('.reviewpads').attribute('class').value.split[1].split('star')
     @city_attractions[:rating] = node[0].capitalize
      puts "Attraction Rating:".colorize(:red) + " #{@city_attractions[:rating]}" + " Stars"
    end 
  end 
  
  def self.scrape_attraction_description
    @page = Nokogiri::HTML(open(@selected_attraction_url))
     node = @page.css('.about-attraction').children.css('p').text
    if node.empty?
      @city_attractions[:description] = "N/A"
    else
     @city_attractions[:description] = node
      puts node
    end
  end
  
  def self.scrape_attraction_crowdrating
    @page = Nokogiri::HTML(open(@selected_attraction_url))
     node = @page.css('.daydetail').first.text
     @city_attractions[:current_crowd_rating] = node
      puts "Current Crowd Rating (Scale 1-10):".colorize(:red) + " #{@city_attractions[:current_crowd_rating]}"
  end 
  
  def self.scrape_attraction_hours
    @page = Nokogiri::HTML(open(@selected_attraction_url))
    node2 = @page.css('.calattraction').attribute('data-filter-ids').value
      if node2.include?('None')
        @city_attractions[:hours] = "N/A"
        puts "Hours:".colorize(:red) + " Unavailable"
      else 
        node = @page.css('.calattraction .filterableitem .caltime')[0].text.strip
        if node.include?('EMH')
          node1 = @page.css('.calattraction .filterableitem .caltime')[1].text.strip
             hours = "#{node} " + "/ #{node1}"
             @city_attractions[:hours] = hours
             puts "Today's Park Hours:".colorize(:red)  +" #{@city_attractions[:hours]}"
        else 
            hours = "#{node}" 
             @city_attractions[:hours] = hours
             puts "Today's Park Hours:".colorize(:red)  +" #{@city_attractions[:hours]}"
        end 
      end  
  end 
  
  def self.scrape_priority_attractions
    @priority_attractions = []
    @page = Nokogiri::HTML(open(@selected_attraction_url))
     node = @page.css('.fff-attractions').children.css('li').children.css('a')
       node.each do |node|
         @priority_attractions << node.text
       end
     if @priority_attractions.empty?
       return nil
     else 
       @city_attractions[:priority_attractions] = @priority_attractions
          puts "Make Time For:".colorize(:red)
       @city_attractions[:priority_attractions].each do |attr|
          print "#{attr}, "
      end
    end
  end
  
  Scraper.city_selector
end 