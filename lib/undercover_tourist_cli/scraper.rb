
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
    @city_page = Nokogiri::HTML(open(@base_path + "/#{city.name.downcase}" +"/attractions"))
    node = @city_page.css('.tiletitle')
      node.each do |node|
        if node.text != "Attraction"
          new = Attractions.new(node.text)
          new.city=(city)
          city.attractions << node.text
        end 
      end
      scrape_urls(city)
    end   
    
   def self.scrape_urls(city)
      @attraction_page = Nokogiri::HTML(open(@base_path + "/#{city.name.downcase}" +"/attractions"))
      node = @attraction_page.css('.tile')
      @url_list = []
        node.each do |node|
           url = node.children.css('a').attribute('href')
              if url != nil 
               @url_list << @base_path + url.value
            end
        end 
        
    end  
    
  def self.attraction_details(attraction)
    @url_list.each do |url|
      if url.include?(attraction.name.downcase.gsub!(/\W+/,' ').split(' ').join('-'))
        binding.pry
        attraction.url=(url)
        attraction_info = Nokogiri::HTML(open(url))
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
        node4 = attraction_info.css('.fff-attractions').children.css('li').children.css('a')
               node4.each do |node|
                 attraction.priority_attractions << node.text
               end
             if attraction.priority_attractions.empty?
               attraction.priority_attractions=("N/A")
             end
        node5 = attraction_info.css('.calattraction').attribute('data-filter-ids').value
              if node5.include?('None')
                attraction.hours=("N/A")
              elsif 
                node6 = attraction_info.css('calattraction .filterableitem').nil?
                  attraction.hours=("N/A")
              elsif 
                node6 = attraction_info.css('.calattraction .filterableitem .caltime')[0].nil?
                 attraction.hours=("N/A")
              else 
                node6 = attraction_info.css('.calattraction .filterableitem .caltime')[0].text.strip
                  if node6 == nil
                    attraction.hours=("N/A")
                  elsif node6.include?('EMH')
                    node7 = attraction_info.css('.calattraction .filterableitem .caltime')[1].text.strip
                       hours = "#{node6} " + "/ #{node7}"
                       attraction.hours=(hours)
                  else 
                       hours = "#{node6}" 
                       attraction.hours=(hours)
                  end 
              end  
          end
        end
      end  
  end 