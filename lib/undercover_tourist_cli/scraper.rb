require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'

class Scraper 
  attr_accessor :city
  
  @base_path = "https://www.undercovertourist.com/"

  
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
    Scraper.scrape_attractions
  end 

  def self.scrape_attractions
    @city = @city.downcase
    page = Nokogiri::HTML(open(@base_path + "/#{@city}"))
    parsed_page = page.css(".cityblurb")
    puts parsed_page
  end 
  
  city_selector
end 