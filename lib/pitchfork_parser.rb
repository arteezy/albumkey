class PitchforkParser
  def initialize(db, collection)
    @collection = Mongo::Client.new(db)[collection]
    @logger = Rails.logger
  end

  def parse_review(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    review = document.at_css('#main .review-meta .info')

    begin
      album = {
        source:     url,
        created_at: Time.now,
        p4k_id:     url.match('/\d{1,6}-')[0][1..-2].to_i,
        artist:     review.css('> h1').text,
        title:      review.css('> h2').text,
        label:      review.css('> h3').text.split(';').first.strip,
        year:       review.css('> h3').text.split(';').last.strip,
        date:       DateTime.strptime(review.css('> h4 > span').text, '%B %d, %Y').to_time,
        rating:     review.css('> span').text.to_f,
        artwork:    review.parent.at_css('.artwork > img').attr('src'),
        reissue:    review.text.include?('Best New Reissue'),
        bnm:        review.text.include?('Best New Music')
      }
    rescue => e
      @logger.error "Failed to parse: #{url}"
      @logger.error e.message
      @logger.error e.backtrace.join("\n")
    end
  end

  def get_page_links(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    document.css('#main .object-grid > li a').map do |review|
      "http://pitchfork.com#{review.attr('href')}"
    end
  end

  def fullscan
    @collection.drop
    (1..find_last_page).each do |page|
      links = get_page_links("http://pitchfork.com/reviews/albums/#{page}/")
      links.map! { |review| parse_review(review) }
      @collection.insert_many(links)
    end
  end

  def update
    latest = Album.desc(:date).limit(1).first
    if Date.today > latest.date
      incremental_update
    else
      @logger.info 'Album database is already synced with Pitchfork'
    end
  end

  def incremental_update(page = 1)
    last_20 = Album.desc(:date).limit(20).map(&:source)
    begin
      links = get_page_links("http://pitchfork.com/reviews/albums/#{page}/") - last_20
      unless links.empty?
        @logger.info 'Found new reviews! Staging them for adding:'
        links.map! do |link|
          @logger.info link
          parse_review(link)
        end
        @collection.insert_many(links)
      end
      page += 1
    end until links.size < 20
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
