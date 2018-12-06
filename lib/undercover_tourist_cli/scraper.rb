
class Scraper 

  @base_path = "https://www.undercovertourist.com"
  
  def self.parse_page(city)
    puts "***********Scraping City******"
    @page = Nokogiri::HTML(open(@base_path + "/#{city.name.downcase}"))
    @page
  end
  
  def self.scrape_city_summary(city)
    Scraper.parse_page(city)
    city.city_summary = @page.css(".cityblurb").children.css("p").text
    binding.pry
  end 
  
  def self.parse_attraction_page
    puts "**********Scrape Attractions*******"
      @attraction_page = Nokogiri::HTML(open(@base_path + "/#{@city}" +"/attractions"))
      return @attraction_page
  end 
  
    def self.scrape_city_attractions(city)
      Scraper.parse_attraction_page
      node = @attraction_page.css('.tiletitle')
        node.each do |node|
          if node.text != "Attraction"
            @attractions << node.text 
          end 
        end
        @attractions.delete("Attraction")
      end   
 
  def self.select_attraction #move to cli
    input = gets.strip.to_i 
    if input > @attractions.size 
      puts "Invalid entry. Please try again."
      Scraper.select_attraction
    end 
    @attractions.select.with_index do |val, index|
      if input == index.to_i + 1
        @selected_attraction = val
        Attractions.name=(@selected_attraction)
      end
    end 
    Scraper.parse_attraction_page
    node = @attraction_page.css('.tile')
      node.each do |node|
       url = node.children.css('a').attribute('href')
        if url != nil
           @attraction_url = @base_path + "#{url}"
           @attraction_urls << @attraction_url
        end
      end 
      @attraction_urls.select.with_index do |val, index|
        if input == index.to_i + 1
          @selected_attraction_url = val
        end
      end
    Scraper.scrape_details
    
  end
  
  def self.parse_selected_attraction_page #(attraction)
    puts "Scrape Attraction Detials *********"
      @page = Nokogiri::HTML(open(@selected_attraction_url))
      return @page
  end 

  def self.scrape_details
    Scraper.parse_selected_attraction_page
    node = @page.css('.reviewpads')
      if node.empty?
        @city_attractions[:rating] = "N/A"
      else
        node1 = @page.css('.reviewpads').attribute('class').value.split[1].split('star')
        @city_attractions[:rating] = node1[0].capitalize + " Stars"
      end
      Attractions.rating=(@city_attractions[:rating])
     node2 = @page.css('.about-attraction').children.css('p').text
        if node2.empty?
          @city_attractions[:description] = "N/A"
        else
         @city_attractions[:description] = node2
        end
        Attractions.description=(@city_attractions[:description])
      node3 = @page.css('.daydetail')
         if node3.nil?
           @city_attractions[:current_crowd_rating] = "N/A"
         else
           @city_attractions[:current_crowd_rating] = node3.first.text
         end
         Attractions.current_crowd_rating=(@city_attractions[:current_crowd_rating])  
      @priority_attractions = []
        node4 = @page.css('.fff-attractions').children.css('li').children.css('a')
             node4.each do |node|
               @priority_attractions << node.text
             end
            if @priority_attractions.empty?
               @city_attractions[:priority_attractions] = "N/A"
             else 
             @city_attractions[:priority_attractions] = @priority_attractions
            end
          Attractions.priority_attractions=(@city_attractions[:priority_attractions])
        node5 = @page.css('.calattraction').attribute('data-filter-ids').value
          if node5.include?('None')
            @city_attractions[:hours] = "N/A"
          elsif 
            node6 = @page.css('calattraction .filterableitem').nil?
              @city_attractions[:hours] = "N/A"
          elsif 
            node6 = @page.css('.calattraction .filterableitem .caltime')[0].nil?
              @city_attractions[:hours] = "N/A"
          else 
            node6 = @page.css('.calattraction .filterableitem .caltime')[0].text.strip
            if node6 == nil
              @city_attractions[:hours] = "N/A"
            elsif node6.include?('EMH')
              node7 = @page.css('.calattraction .filterableitem .caltime')[1].text.strip
                 hours = "#{node6} " + "/ #{node7}"
                 @city_attractions[:hours] = hours
              else 
                hours = "#{node6}" 
                 @city_attractions[:hours] = hours
            end 
          end  
          Attractions.hours=(@city_attractions[:hours])
          #Attractions.clear
          x = Attractions.new(@selected_attraction, @city_attractions[:description], @city_attractions[:rating], @city_attractions[:current_crowd_rating], @city_attractions[:priority_attractions], @city_attractions[:hours])
       
         
    end 
    
    
end 