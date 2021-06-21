class PitchforkParserService
  def initialize(db, collection)
    @db = Mongo::Client.new(db)
    @collection = @db[collection]
    @logger = Rails.logger.extend(
      ActiveSupport::Logger.broadcast(
        ActiveSupport::Logger.new($stdout)
      )
    )
  end

  def parse_review(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    if document.at_xpath("//header[contains(@class,'MultiReviewContent')]").present?
      @logger.warn "Skipping multi-review: #{url}"
      return
    end

    review = document.at_xpath("//div[contains(@class,'SplitScreenContentHeaderForMusicReview')]")
    meta = document.xpath("//div[contains(@class,'SplitScreenContentHeaderGrid')]")

    album = {
      source:     url,
      created_at: Time.zone.now,
      updated_at: Time.zone.now,
      p4k_id:     pitchfork_id(url),
      artist:     [review.at_xpath(".//div[contains(@class,'SplitScreenContentHeaderArtist')]").text],
      title:      review.at_xpath(".//h1[contains(@class,'SplitScreenContentHeaderHed')]").text,
      year:       review.at_xpath(".//time[contains(@class,'SplitScreenContentHeaderReleaseYear')]")&.text || meta_date(meta).year,
      genre:      meta_genre(meta),
      label:      meta_label(meta),
      date:       meta_date(meta),
      reviewer:   review.next.at_xpath(".//span[contains(@class,'BylineName')]/a").text,
      rating:     review.at_xpath(".//div[contains(@class,'SplitScreenContentHeaderScoreBox')]").text.to_f,
      artwork:    review.at_xpath(".//picture[contains(@class,'SplitScreenContentHeaderLede')]/img").attr(:src),
      reissue:    review.text.include?('Best New Reissue'),
      bnm:        review.text.include?('Best New Music')
    }
    album.compact
  rescue => e
    @logger.error "Failed to parse: #{url}"
    @logger.error e.message
    @logger.error e.backtrace.join('\n')
  end

  def pitchfork_id(url)
    match = url.match('/\d{5,7}-')
    match ? match[0][1..-2].to_i : match
  end

  def meta_genre(meta)
    genre = meta.at_xpath(".//ul/li/div/p[contains(text(),'Genre:')]")
    genre ? [genre.next.text] : nil
  end

  def meta_label(meta)
    label = meta.at_xpath(".//ul/li/div/p[contains(text(),'Label:')]")
    label ? [label.next.text] : ["self-released"]
  end

  def meta_date(meta)
    date = meta.at_xpath(".//ul/li/div/p[contains(text(),'Reviewed:')]")
    date ? Date.parse(date.next.text).to_datetime : Time.zone.today
  end

  def get_page_links(url)
    document = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    document.xpath("//a[contains(@class,'SummaryItemHedLink')]").map do |review|
      "https://pitchfork.com#{review.attr(:href)}"
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

  def frontpage
    latest_albums_links = Album.desc(:date).limit(100).pluck(:source)
    begin
      links = get_page_links("https://pitchfork.com/reviews/albums/") - latest_albums_links
      unless links.empty?
        @logger.info 'Found new reviews! Staging them for crawling:'
        links.each do |link|
          @logger.info link
          album = parse_review(link)
          @collection.insert_one(album) if album
        end
        @logger.info 'Review batch was successfully written to the DB'
      end
    rescue Mongo::Error::OperationFailure => e
      @logger.error e.result
    end
  end

  def update
    latest = Album.desc(:date).limit(1).first
    if Time.zone.today > latest.date
      incremental_update
    else
      @logger.info 'Album database is already synced with Pitchfork'
    end
  end

  def incremental_update(page = 1)
    latest_albums_links = Album.desc(:date).limit(100).pluck(:source)
    loop do
      links = get_page_links("https://pitchfork.com/reviews/albums/?page=#{page}") - latest_albums_links
      unless links.empty?
        @logger.info 'Found new reviews! Staging them for crawling:'
        links.each do |link|
          @logger.info link
          album = parse_review(link)
          @collection.insert_one(album) if album
        end
        @logger.info 'Review batch was successfully written to the DB'
      end
      page += 1
    rescue Mongo::Error::OperationFailure => e
      @logger.error e.result
    end
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
