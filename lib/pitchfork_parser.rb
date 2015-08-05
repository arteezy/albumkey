class PitchforkParser
  include Mongo

  def initialize(db, collection)
    @collection = Mongo::Client.new(['localhost'], database: db)[collection]
  end

  def parse_review(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    review = document.at_css('#main .review-meta .info')
    album = {
      source:  url,
      p4k_id:  url.match('/\d{1,6}-')[0][1..-2],
      artist:  review.css('> h1').text,
      title:   review.css('> h2').text,
      label:   review.css('> h3').text.split(';').first.strip,
      year:    review.css('> h3').text.split(';').last.strip,
      date:    DateTime.strptime(review.css('> h4 > span').text, '%B %d, %Y').to_time,
      rating:  review.css('> span').text.to_f,
      artwork: review.parent.at_css('.artwork > img').attr('src'),
      reissue: review.text.include?('Best New Reissue'),
      bnm:     review.text.include?('Best New Music')
    }
  end

  def parse_review_links(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    grid = document.css('#main .object-grid > li a').map do |review|
      review_url = "http://pitchfork.com#{review.attr('href')}"
      parse_review(review_url)
    end
  end

  def fullscan
    @collection.drop
    (1...find_last_page).each do |page|
      page = parse_review_links("http://pitchfork.com/reviews/albums/#{page}/")
      @collection.insert_many(page)
    end
  end

  def footprint
    if Date.today > Album.desc(:date).limit(1).first.date
      update
    else
      puts 'Album database is synced with Pitchfork'
    end
  end

  def update
    puts 'WIP'
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
