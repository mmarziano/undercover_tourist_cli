#require_relative "../undercover_tourist_cli/version"
require_relative "undercover_tourist_cli/scraper"

class UndercoverTouristCli

  def call
    puts "---------------------------------"
    puts "Welcome to the Undercover Tourist"
    puts "---------------------------------"
    puts "What city would you like to explore? Type 1 for" + " Orlando".colorize(:green) +", 2 for " + "Los Angeles".colorize(:yellow)+ ", 3 for " + "San Diego".colorize(:blue)+ ", or" + " Exit".colorize(:red) + " to exit."
    Scraper.city_selector
  end

end

UndercoverTouristCli.new.call