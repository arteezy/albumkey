class PitchforkParser
  def initialize(db, collection)
    @collection = Mongo::Client.new(db)[collection]
    @logger = Rails.logger
  end

  def parse_review(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    review = document.at_css('.tombstone')

    begin
      album = {
        source:     url,
        created_at: Time.now,
        p4k_id:     url.match('/\d{1,6}-')[0][1..-2].to_i,
        artist:     review.css('.artists > ul > li').map(&:text).join(' / '),
        title:      review.css('.review-title').text,
        label:      review.css('.label-list > li').map(&:text).join(' / '),
        year:       review.css('.year > span:last-child').text,
        date:       Date.parse(document.css('.pub-date').attr('title')).to_datetime,
        rating:     review.css('.score').text.to_f,
        artwork:    review.parent.at_css('.album-art > img').attr('src'),
        reissue:    review.text.include?('Best new reissue'),
        bnm:        review.text.include?('Best new music')
      }
    rescue => e
      @logger.error "Failed to parse: #{url}"
      @logger.error e.message
      @logger.error e.backtrace.join("\n")
    end
  end

  def get_page_links(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    document.css('.fragment-list > .review > a').map do |review|
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

  def incremental_update(page = 1, batch_size = 24)
    latest_albums_links = Album.desc(:date).limit(batch_size).pluck(:source)
    begin
      links = get_page_links("http://pitchfork.com/reviews/albums/?page=#{page}") - latest_albums_links
      unless links.empty?
        @logger.info 'Found new reviews! Staging them for parsing:'
        links.map! do |link|
          @logger.info link
          parse_review(link)
        end
        @collection.insert_many(links)
      end
      batch_size = 12
      page += 1
    end until links.size < batch_size
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
