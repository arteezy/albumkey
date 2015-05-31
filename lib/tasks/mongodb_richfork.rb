require 'open-uri'
require 'nokogiri'
require 'mongo'

include Mongo

@db = MongoClient.new("localhost", 27017).db("richfork")
@collection = "albums"

def parse_review(url)
  doc = Nokogiri::HTML(open(url))

  begin
    artist     = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h1').first.content.strip
    title      = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h2').first.content.strip
    label_year = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h3').first.content.split(';')
    label      = label_year[0].strip
    year       = label_year[1].strip
    date_raw   = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/h4/span').first.content.strip
    date       = DateTime.strptime(date_raw, "%B %d, %Y")
    rating     = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/span').first.content.strip
    artwork    = doc.xpath('//div[@id = "main"]/*/*/div[@class = "artwork"]/img/@src').first.content.strip
    bnm        = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/div[@class = "bnm-label"]').first.content.include?("Best New Music")
    reissue    = doc.xpath('//div[@id = "main"]/*/*/div[@class = "info"]/div[@class = "bnm-label"]').first.content.include?("Best New Reissue")
  rescue Exception => e
    puts "Failed to parse: " + url
    puts e.message
    puts e.backtrace
  end

  review = {
    id:      url.match('/\d{1,5}-')[0][1..-2],
    source:  url,
    artist:  artist,
    title:   title,
    label:   label,
    year:    year.empty? ? date.year.to_s : year,
    date:    date.to_time,
    rating:  rating.to_f,
    artwork: artwork,
    reissue: reissue,
    bnm:     bnm
  }
end

# test
# 1.times do
#   puts parse_review('http://pitchfork.com/reviews/albums/18703-the-rise-fall-of-paramount-records-volume-one-1917-1932/')
#   puts parse_review('http://pitchfork.com/reviews/albums/17675-how-to-destroy-angels-welcome-oblivion/')
#   puts parse_review('http://pitchfork.com/reviews/albums/17253-good-kid-maad-city/')
#   puts parse_review('http://pitchfork.com/reviews/albums/17272-iii/')
#   puts parse_review('http://pitchfork.com/reviews/albums/18779-death-grips-government-plates/')
#   puts parse_review('http://pitchfork.com/reviews/albums/2099-just-say-sire/')
# end

def scan_pages(first_page, last_page)
  for i in first_page..last_page
    parse_review_links('http://pitchfork.com/reviews/albums/' + i.to_s)
  end
end

def parse_review_links(url)
  page = []
  doc = Nokogiri::HTML(open(url))
  doc.xpath('//div[@id = "main"]/ul[@class = "object-grid "]/li/ul/li/a/@href').each do |review|
    next if review.to_s == '/reviews/albums/1365-no-more-shall-we-part/'
    page << parse_review('http://pitchfork.com' + review)
  end
  @db[@collection].insert(page, w: 1)
end

def parallel_scan(threads, pages)
  unless pages % threads == 0
    puts "Can't split pages to threads! Number of pages should be evenly divisible by threads."
    return
  end

  x = pages / threads
  pool = []

  for t in 1..threads
    pool << Thread.new { scan_pages(((t - 1) * x) + 1, t * x) }
  end

  pool.map(&:join)
end

@db.drop_collection(@collection)
# parallel_scan(10, 750)
scan_pages(1, 833)
