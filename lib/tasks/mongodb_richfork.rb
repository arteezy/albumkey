require 'open-uri'
require 'nokogiri'
require 'mongo'

include Mongo

@db = MongoClient.new("localhost", 27017).db("pitchfork")
@reviews = @db["articles"]

def parse_review(url)
  doc = Nokogiri::HTML(open(url))

  begin
    artist     = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h1').first.content.strip
    title      = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h2').first.content.strip
    label_year = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h3').first.content.strip.split(';')
    label      = label_year[0].strip
    year       = label_year[1].strip unless label_year.empty?
    date_raw   = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h4/span').first.content.strip
    date       = DateTime.strptime(date_raw, "%B %d, %Y")
    score      = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/span').first.content.strip
    artwork    = doc.xpath('//div[@id = "main"]/*/*/div[@class = "artwork"]/img/@src').first.content.strip
    bnm        = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/div[@class = "bnm-label"]').first.content.include?("Best New Music")
    bnr        = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/div[@class = "bnm-label"]').first.content.include?("Best New Reissue")
  rescue
    puts "Failed to parse: " + url
  end

  review = {
    id:      url.match('/\d{1,5}-')[0][1..-2],
    url:     url,
    artist:  artist,
    title:   title,
    label:   label,
    year:    year,
    date:    date.to_time,
    score:   score,
    artwork: artwork,
    bnm:     bnm,
    bnr:     bnr
  }
end

def scan_pages(last_page)
  for i in 1..last_page
    parse_review_links('http://pitchfork.com/reviews/albums/' + i.to_s)
  end
end

def parse_review_links(url)
  page = []
  doc = Nokogiri::HTML(open(url))
  doc.xpath('//div[@id = "main"]/ul[@class = "object-grid "]/li/ul/li/a/@href').each do |review|
    page << parse_review('http://pitchfork.com' + review)
  end
  @reviews.insert(page)
end

scan_pages(500)
