class AlbumWallGenerator
  attr_reader :bnm, :tmp, :output

  def initialize(bnm, tmp = 'tmp', output = 'public/assets')
    @bnm = bnm
    @tmp = tmp
    @output = output
  end

  def preload_images
    albums =
      if bnm
        Album.where(bnm: bnm).order(date: :desc).limit(12).pluck(:artwork)
      else
        Album.order(date: :desc).limit(12).pluck(:artwork)
      end

    albums.map.with_index do |album, index|
      cover = MiniMagick::Image.open album
      filename = "#{tmp}/#{index + 1}.jpg"
      cover.write filename
      filename
    end
  end

  def add_border(filename, size, color = 'White')
    MiniMagick::Tool::Convert.new do |convert|
      convert << filename

      convert.bordercolor << color
      convert.border << "#{size}x#{size}"

      convert << filename
    end
  end

  def ribbon(filenames, result)
    filenames *= 2

    MiniMagick::Tool::Convert.new do |convert|
      convert.append

      filenames.each do |i|
        convert << i
      end

      convert << "#{tmp}/#{result}.jpg"
    end
  end

  def shifted_ribbon(filenames, result, percent)
    first = filenames.shift

    MiniMagick::Tool::Convert.new do |convert|
      convert.crop

      convert << "100%x#{percent}%"

      convert << first
      convert << "#{tmp}/split.jpg"
    end

    if percent < 50
      MiniMagick::Tool::Convert.new do |convert|
        convert.append

        convert << "#{tmp}/split-1.jpg"
        convert << "#{tmp}/split-2.jpg"
        convert << "#{tmp}/split-3.jpg"

        convert << "#{tmp}/split-1.jpg"
      end
    end

    filenames.unshift "#{tmp}/split-1.jpg"
    filenames.push "#{tmp}/split-0.jpg"

    ribbon(filenames, result)
  end

  def gen_ribbon(filenames, result, percent = nil)
    if percent
      shifted_ribbon(filenames, result, percent)
    else
      ribbon(filenames, result)
    end
  end

  def combine_ribbons(left, right, result)
    MiniMagick::Tool::Convert.new do |convert|
      convert.append.+

      convert << "#{tmp}/#{left}.jpg"
      convert << "#{tmp}/#{right}.jpg"

      convert << "#{result}.jpg"
    end
  end

  def generate_wall
    filenames = preload_images

    gen_ribbon(filenames[0..2], 'r1')
    gen_ribbon(filenames[3..5], 'r2', 66)
    combine_ribbons('r1', 'r2', "#{tmp}/left")

    gen_ribbon(filenames[6..8], 'r4')
    gen_ribbon(filenames[9..11], 'r3', 33)
    combine_ribbons('r3', 'r4', "#{tmp}/right")

    combine_ribbons('left', 'right', "#{output}/wall")

    Rails.logger.info 'Successfully generated album wall'
  end
end
