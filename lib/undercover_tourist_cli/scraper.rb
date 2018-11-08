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
    Scraper.scrape_attraction_details
  end
  
  
  def self.scrape_attraction_details
    @page = Nokogiri::HTML(open(@selected_attraction_url))
    node = @page.css('.reviewpads').children.css('span').attribute('class').value
   #node.each do |node|
      #node.inspect
    puts node
    #@city_attractions[:rating] = @page.css(".darkblue").inner_text
    #puts @city_attractions[:rating]
  end 
  
  Scraper.city_selector
end 