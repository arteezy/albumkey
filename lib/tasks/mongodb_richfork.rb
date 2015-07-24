require 'net/http'
require 'nokogiri'
require 'mongo'

class Parser
  include Mongo

  def initialize(db, collection)
    @db = Mongo::Client.new(['localhost'], database: db)
    @collection = collection
  end

  def parse_review(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    review = document.at_css('#main .review-meta .info')

    begin
      artist      = review.css('> h1').text
      title       = review.css('> h2').text
      label, year = review.css('> h3').text.split(';').map(&:strip)
      date_raw    = review.css('> h4 > span').text
      date        = DateTime.strptime(date_raw, '%B %d, %Y')
      rating      = review.css('> span').text
      artwork     = review.parent.at_css('.artwork > img').attr('src')
      reissue     = review.text.include?('Best New Reissue')
      bnm         = review.text.include?('Best New Music')
    rescue => e
      puts "Failed to parse: #{url}"
      puts e.message
      puts e.backtrace
    end

    review = {
      source:  url,
      p4k_id:  url.match('/\d{1,6}-')[0][1..-2],
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

  def parse_pages(first_page, last_page)
    (first_page...last_page).each do |page|
      parse_review_links("http://pitchfork.com/reviews/albums/#{page}/")
    end
  end

  def parse_review_links(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    grid = document.css('#main .object-grid > li a').map do |review|
      review = review.attr('href')
      next if review == '/reviews/albums/1365-no-more-shall-we-part/'
      parse_review("http://pitchfork.com#{review}")
    end
    @db[@collection].insert_many(grid)
  end

  def fullscan
    @db[@collection].drop
    parse_pages(1, find_last_page)
  end

  def find_last_page
    max = 2**16
    binsearch(1, max)
  end

  def binsearch(start, fin)
    return start if start == fin - 1

    mid = (start + fin) / 2
    url = "http://pitchfork.com/reviews/albums/#{mid}/"
    response = Net::HTTP.get_response(URI(url))

    if response.code == '200'
      binsearch(mid, fin)
    else
      binsearch(start, mid)
    end
  end
end

parser = Parser.new('richfork', 'albums')
parser.fullscan
