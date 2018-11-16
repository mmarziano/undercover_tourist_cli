

class Scraper 
  attr_accessor :city, :page, :attractions
  
  @base_path = "https://www.undercovertourist.com"
  @city_attractions = {}
  @attractions = []
  @attraction_urls = []
  
  def self.city=(city)
    @city = city.downcase
  end 

  def self.city 
    @city
  end 
  
  def self.parse_page
    @page = Nokogiri::HTML(open(@base_path + "/#{@city}"))
    return @page
  end

  def self.scrape_city_summary
    @page = Nokogiri::HTML(open(@base_path + "/#{@city}"))
    @city_attractions[:city_summary] = @page.css(".cityblurb").children.css("p").text
    City.city_summary=(@city_attractions[:city_summary])
    City.city_summary
  end 
  
  def self.scrape_city_attractions
    @page = Nokogiri::HTML(open(@base_path + "/#{@city}" +"/attractions"))
    node = @page.css('.tile .tiletitle')
      node.each do |node|
       @attractions << node.text
       Attractions.new(node.text)
      end
    @city_attractions[:attractions] = @attractions
    Attractions.all
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
    Attractions.name=(@selected_attraction)
    Scraper.scrape_attraction_rating
  end
  
  
  def self.scrape_attraction_rating
    @page = Nokogiri::HTML(open(@selected_attraction_url))
    node1 = @page.css('.reviewpads')
    if node1.empty?
      @city_attractions[:rating] = "N/A"
    else
      node = @page.css('.reviewpads').attribute('class').value.split[1].split('star')
      @city_attractions[:rating] = node[0].capitalize + " Stars"
    end
      Attractions.rating=(@city_attractions[:rating])
      Scraper.scrape_attraction_description
  end 
  
  def self.scrape_attraction_description
    @page = Nokogiri::HTML(open(@selected_attraction_url))
     node = @page.css('.about-attraction').children.css('p').text
    if node.empty?
      @city_attractions[:description] = "N/A"
    else
     @city_attractions[:description] = node
    end
    Attractions.description=(@city_attractions[:description])
    Scraper.scrape_attraction_crowdrating
  end
  
  def self.scrape_attraction_crowdrating
    @page = Nokogiri::HTML(open(@selected_attraction_url))
     node = @page.css('.daydetail').first.text
     @city_attractions[:current_crowd_rating] = node
     Attractions.current_crowd_rating=(@city_attractions[:current_crowd_rating])
     Scraper.scrape_attraction_hours
  end 
  
  def self.scrape_attraction_hours
    @page = Nokogiri::HTML(open(@selected_attraction_url))
    node2 = @page.css('.calattraction').attribute('data-filter-ids').value
      if node2.include?('None')
        @city_attractions[:hours] = "N/A"
      elsif 
        node = @page.css('calattraction .filterableitem').nil?
          @city_attractions[:hours] = "N/A"
      elsif 
        node = @page.css('.calattraction .filterableitem .caltime')[0].nil?
          @city_attractions[:hours] = "N/A"
      else 
        node = @page.css('.calattraction .filterableitem .caltime')[0].text.strip
        if node == nil
          @city_attractions[:hours] = "N/A"
        elsif node.include?('EMH')
          node1 = @page.css('.calattraction .filterableitem .caltime')[1].text.strip
             hours = "#{node} " + "/ #{node1}"
             @city_attractions[:hours] = hours
        else 
            hours = "#{node}" 
             @city_attractions[:hours] = hours
        end 
      end  
      Attractions.hours=(@city_attractions[:hours])
      Scraper.scrape_priority_attractions
  end 
  
  def self.scrape_priority_attractions
    @priority_attractions = []
    @page = Nokogiri::HTML(open(@selected_attraction_url))
       node = @page.css('.fff-attractions').children.css('li').children.css('a')
         node.each do |node|
           @priority_attractions << node.text
         end
     if @priority_attractions.empty?
         @city_attractions[:priority_attractions] = "N/A"
       else 
         @city_attractions[:priority_attractions] = @priority_attractions
       end
      Attractions.priority_attractions=(@city_attractions[:priority_attractions])
      UndercoverTouristCli.results
  end
  
  
end 