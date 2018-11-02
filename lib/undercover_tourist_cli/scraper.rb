require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'

class Scraper 
  attr_accessor :city, :page, :attractions
  
  @base_path = "https://www.undercovertourist.com/"
  @city_attractions = {}
  @attractions = []
  
  
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
    puts @city_attractions
    
  
  end 
  
  
  city_selector
end 