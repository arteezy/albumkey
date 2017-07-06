class PitchforkParserService
  def initialize(db, collection)
    @db = Mongo::Client.new(db)
    @collection = @db[collection]
    @logger = Rails.logger
  end

  def parse_review(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    review = document.at_css('.single-album-tombstone')
    meta = document.at_css('.article-meta')
    album = {
      source:     url,
      created_at: Time.now,
      p4k_id:     pitchfork_id(url),
      artist:     review.css('.artist-list > li').map(&:text),
      title:      review.css('.single-album-tombstone__review-title').text,
      label:      review.css('.labels-list > li').map(&:text),
      year:       review.css('.single-album-tombstone__meta-year').text.split(' • ')[1],
      date:       Date.parse(meta.css('.pub-date').attr('title')).to_datetime,
      genre:      meta.css('.genre-list > li > a').map(&:text),
      reviewer:   meta.css('.authors-detail > li > div > a').text,
      rating:     review.css('.score').text.to_f,
      artwork:    review.parent.at_css('.single-album-tombstone__art > img').attr('src'),
      reissue:    review.text.include?('Best new reissue'),
      bnm:        review.text.include?('Best new music')
    }
    album.compact
  rescue => e
    @logger.error "Failed to parse: #{url}"
    @logger.error e.message
    @logger.error e.backtrace.join("\n")
    retry
  end

  def pitchfork_id(url)
    match = url.match('/\d{5,7}-')
    match ? match[0][1..-2].to_i : match
  end

  def get_page_links(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    document.css('.fragment-list > .review > a').map do |review|
      "https://pitchfork.com#{review.attr('href')}"
    end
  end

  def prepare_link_list
    @db[:links].drop
    (1..find_last_page).each do |page|
      @logger.info "Crawling page: #{page}"
      links = get_page_links("http://pitchfork.com/reviews/albums/?page=#{page}")

      tries ||= 15
      if links.empty? && tries > 0
        tries -= 1
        redo
      end

      links.map! do |link|
        { URL: link, parsed: false }
      end
      @db[:links].insert_many links
    end
  end

  def fullscan
    @collection.drop
    @db[:links].find.each_slice(50) do |batch|
      batch.map! { |review| parse_review review[:URL] }
      @collection.insert_many batch
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
      links = get_page_links("https://pitchfork.com/reviews/albums/?page=#{page}") - latest_albums_links
      unless links.empty?
        @logger.info 'Found new reviews! Staging them for crawling:'
        links.map! do |link|
          @logger.info link
          parse_review(link)
        end
        @collection.insert_many(links)
        @logger.info 'Review batch was successfully written to the DB'
      end
      batch_size = 12
      page += 1
    rescue Mongo::Error::BulkWriteError => e
      @logger.error e.result
    end until links.size < batch_size
  end

  def find_last_page
    max = 2**16
    binsearch(1, max)
  end

  def binsearch(start, fin)
    return start if start == fin - 1

    mid = (start + fin) / 2
    url = "http://pitchfork.com/reviews/albums/?page=#{mid}"
    response = Net::HTTP.get_response(URI(url))

    if response.code == '200'
      binsearch(mid, fin)
    else
      binsearch(start, mid)
    end
  end
end
