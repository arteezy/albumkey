require 'open-uri'
require 'nokogiri'
require 'mongo'

include Mongo

@db = MongoClient.new("localhost", 27017).db("pitchfork")
@reviews = @db["dater"]
@bulk = Array.new

def parse(url)
    doc = Nokogiri::HTML(open(url))

    begin
        artist      = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h1')[0].content.to_s.strip
        title       = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h2')[0].content.to_s.strip
        label_year  = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h3')[0].content.to_s.strip.split(';')
        label       = label_year[0].strip
        year        = label_year[1].strip if label_year.size > 1
        date_raw    = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h4/span')[0].content.to_s.strip
        date        = Date.strptime(date_raw, "%B %d, %Y")
        score       = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/span')[0].content.to_s.strip
        artwork     = doc.xpath('//div[@id = "main"]/*/*/div[@class = "artwork"]/img/@src')[0].content.to_s.strip
    rescue
        puts url
    end

    item = {
        "id"        => url.match('/\d{1,5}-')[0][1..-2],
        "url"       => url,
        "artist"    => artist,
        "title"     => title,
        "label"     => label,
        "year"      => year,
        "date"      => date.to_s,
        "score"     => score,
        "artwork"   => artwork
    }
    item
end

1.times do
    puts parse('http://pitchfork.com/reviews/albums/17675-how-to-destroy-angels-welcome-oblivion/')
    puts parse('http://pitchfork.com/reviews/albums/17253-good-kid-maad-city/')
    puts parse('http://pitchfork.com/reviews/albums/17272-iii/')
end

def list
    i = 1
    while (i < 200) do
        links('http://pitchfork.com/reviews/albums/' + i.to_s)
        i+=1
    end
end

def links(url)
    doc = Nokogiri::HTML(open(url))  
    doc.xpath('//div[@id = "main"]/ul[@class = "object-grid "]/li/ul/li/a/@href').each do |elem|
        @bulk << parse('http://pitchfork.com' + elem) 
        if @bulk.size > 32
            @reviews.insert(@bulk)
            @bulk.clear
        end
    end
end

#list
