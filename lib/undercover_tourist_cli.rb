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
    input = gets.strip.downcase.split(' ').join('-')
    if input == "orlando" || input == "los-angeles" || input == "san-diego"
      Scraper.city=(input)
      Scraper.scrape_city_summary
    elsif input == "exit"
      puts "Exiting."
    else 
      puts "Entry not recognized. Please check spelling and try again."
      city_selector
   end 
    puts "Great choice! Here's some more information on " + Scraper.city.capitalize + 
    ". " + City.city_summary
    UndercoverTouristCli.pick_attraction
  end 
  
  def self.pick_attraction
    puts "-------------------------------"
    puts "Below is a list of attractions:"
    puts "-------------------------------"
    Scraper.scrape_city_attractions
          i = 1
          Attractions.all.each do |attraction|
            puts "#{i}.".colorize(:red) + " #{attraction.name}".colorize(:blue)
            i += 1
          end 
        puts "Please select a number from the list above."
        Scraper.select_attraction
  end 
  
  def self.results
    puts 
  end 
  
  end

UndercoverTouristCli.new.call