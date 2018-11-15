require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'
#require_relative "../undercover_tourist_cli/version"
require_relative "undercover_tourist_cli/scraper"
require_relative "undercover_tourist_cli/city"

class UndercoverTouristCli

  def call
    puts "---------------------------------"
    puts "Welcome to the Undercover Tourist"
    puts "---------------------------------"
    puts "What city would you like to explore? Type" + " Orlando".colorize(:green) +",  " + "Los Angeles".colorize(:yellow)+ ", " + "San Diego".colorize(:blue)+ ", or" + " Exit".colorize(:red) + " to exit."
    city_selector
  end

  def city_selector 
    input = gets.strip.downcase
    case input 
    when input = "orlando"
      @city = City.new("Orlando").city
      Scraper.city(@city)
      puts "You have selected #{@city}."
    when input = "los angeles" 
      @city = City.new("Los-Angeles").city
      puts "You have selected #{@city}."
    when input = "san diego" 
      @city = City.new("San-Diego").city
      puts "You have selected #{@city}."
    when input = "Exit".downcase
      @city = nil
      puts "Exiting."
    else 
      puts "Entry not recognized. Please try again."
      city_selector
   end 
   Scraper.scrape_city_summary
   Scraper.scrape_city_attractions
   pick_attraction
  end 
  
  def pick_attraction
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
  
  
  end

UndercoverTouristCli.new.call