class DiscogsParserService
  def initialize(wrapper, num_threads = 2)
    @wrapper = wrapper
    @num_threads = num_threads
  end

  def parse(year)
    Album.where(discogs: nil, year: year).each do |album|
      search = @wrapper.search("#{album[:artist]} #{album[:title]}")
      unless search[:results].blank?
        search[:results].each do |result|
          if result[:type] == 'master' && result[:year] == album[:year]
            album[:discogs] = result
            puts "#{album[:artist]} - #{album[:title]}"
            album.save!
            break
          end
        end
      end
    end
  end

  def queue_start
    years = Album.where(discogs: nil).distinct(:year)
    queue = Queue.new
    years.each { |year| queue.push(year) }

    threads = []
    @num_threads.times do
      threads << Thread.new do
        while (year = queue.pop(true) rescue nil)
          parse(year)
        end
      end
    end
    threads.map(&:join)
  end

  def thread_pool_start
    pool = Concurrent::FixedThreadPool.new(@num_threads)

    years = Album.where(discogs: nil).distinct(:year)
    years.each do |year|
      pool.post do
        puts "Parsing #{year} year!"
        parse(year)
      end
    end

    pool.shutdown
    pool.wait_for_termination
  end
end
