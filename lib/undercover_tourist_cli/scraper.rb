
class Scraper 

  @base_path = "https://www.undercovertourist.com"
  
  def self.parse_page(city)
    @page = Nokogiri::HTML(open(@base_path + "/#{city.name.downcase}"))
    @page
  end
  
  def self.scrape_city_summary(city)
    Scraper.parse_page(city)
    city.city_summary = @page.css(".cityblurb").children.css("p").text
  end 
  
    def self.scrape_city_attractions(city)
      @attraction_page = Nokogiri::HTML(open(@base_path + "/#{city.name.downcase}" +"/attractions"))
      node = @attraction_page.css('.tiletitle')
        node.each do |node|
          if node.text != "Attraction"
            new = Attractions.new(node.text)
            new.city=(city)
            city.attractions << node.text
          end 
        end
        Attractions.all
      end   
    
  def self.attraction_details(attraction)
    @attraction_page = Nokogiri::HTML(open(@base_path + "/#{attraction.city.name.downcase}" +"/attractions"))
    node = @attraction_page.css('.tile')
    Attractions.all.each do |x| 
       if x.name == attraction.name
         url = node.children.css('a').attribute('href')
            if url != nil
               attraction.url=(@base_path + "#{url}")
            end
        end 
      end
    attraction_info = Nokogiri::HTML(open(attraction.url))
    node = attraction_info.css('.reviewpads')
      if node.empty?
        attraction.rating=("N/A")
      else
        node1 = attraction_info.css('.reviewpads').attribute('class').value.split[1].split('star')
        attraction.rating=(node1[0].capitalize + " Stars")
      end
    node2 = attraction_info.css('.about-attraction').children.css('p').text
        if node2.empty?
          attraction.description=("N/A")
        else
         attraction.description=(node2)
        end
    node3 = attraction_info.css('.daydetail')
         if node3.nil?
           attraction.current_crowd_rating=("N/A")
         else
           attraction.current_crowd_rating=(node3.first.text)
         end
     #@priority_attractions = []
        #node4 = attraction_info.css('.fff-attractions').children.css('li').children.css('a')
             #node4.each do |node|
               #@priority_attractions << node.text
             #end
            #if @priority_attractions.empty?
               #@city_attractions[:priority_attractions] = "N/A"
             #else 
             #@city_attractions[:priority_attractions] = @priority_attractions
            #end
          #Attractions.priority_attractions=(@city_attractions[:priority_attractions])
        #node5 = attraction_info.css('.calattraction').attribute('data-filter-ids').value
          #if node5.include?('None')
            #@city_attractions[:hours] = "N/A"
          #elsif 
            #node6 = attraction_info.css('calattraction .filterableitem').nil?
              #@city_attractions[:hours] = "N/A"
          #elsif 
            #node6 = attraction_info.css('.calattraction .filterableitem .caltime')[0].nil?
             # @city_attractions[:hours] = "N/A"
          #else 
            #node6 = attraction_info.css('.calattraction .filterableitem .caltime')[0].text.strip
            #if node6 == nil
              #@city_attractions[:hours] = "N/A"
            #elsif node6.include?('EMH')
              #node7 = attraction_info.css('.calattraction .filterableitem .caltime')[1].text.strip
                 #hours = "#{node6} " + "/ #{node7}"
                 #@city_attractions[:hours] = hours
              #lse 
                #hours = "#{node6}" 
                 #@city_attractions[:hours] = hours
            #end 
          #end  
          #Attractions.hours=(@city_attractions[:hours])
          #Attractions.clear
          #x = Attractions.new(@selected_attraction, @city_attractions[:description], @city_attractions[#:rating], @city_attractions[:current_crowd_rating], @city_attractions[:priority_attractions]#, @city_attractions[:hours])
    binding.pry
    
    
  end
  
  def self.parse_selected_attraction_page(selected_attraction)
    puts "******* Acquiring Attraction Details *********"
      @page = Nokogiri::HTML(open(attraction.url))
      return @page
  end 

  def self.scrape_details(attraction_url)
    Scraper.parse_selected_attraction_page(attraction_url)
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