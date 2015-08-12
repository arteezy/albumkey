class PitchforkParser
  include Mongo

  def initialize(db, collection)
    client = Mongo::Client.new(db)
    @collection = client[collection]
  end

  def parse_review(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    review = document.at_css('#main .review-meta .info')

    begin
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
    rescue => e
      puts "Failed to parse: #{url}"
      puts e.message
      puts e.backtrace
    end
  end

  def get_page_links(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    document.css('#main .object-grid > li a').map do |review|
      review_url = "http://pitchfork.com#{review.attr('href')}"
    end
  end

  def fullscan
    @collection.drop
    (1...find_last_page).each do |page|
      links = get_page_links("http://pitchfork.com/reviews/albums/#{page}/")
      links.map! { |review| parse_review(review) }
      @collection.insert_many(links)
    end
  end

  def update
    latest = Album.desc(:date).limit(1).first
    if Date.today > latest.date
      catch_up_to(latest.source)
      puts 'Successfully updated album database'
    else
      puts 'Album database is synced with Pitchfork'
    end
  end

  def catch_up_to(url)
    page = 1
    begin
      links = get_page_links("http://pitchfork.com/reviews/albums/#{page}/")
      links.each do |review|
        json = parse_review(review)
        @collection.update_one(json, json, upsert: true)
      end
      page += 1
    end until links.include?(url)
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
