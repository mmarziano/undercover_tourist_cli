#require_relative "../undercover_tourist_cli/version"
require_relative "undercover_tourist_cli/scraper"

module UndercoverTouristCli::Scraper
  def start
    Scraper.city_selector
  end
    
end
