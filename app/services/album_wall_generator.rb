class AlbumWallGenerator
  attr_reader :bnm, :tmp, :output

  def initialize(bnm, tmp = 'tmp', output = 'public/assets')
    @bnm = bnm
    @tmp = tmp
    @output = output
  end

  def prepare_images
    albums =
      if bnm
        Album.where(bnm: bnm).order(date: :desc).limit(12).pluck(:artwork)
      else
        Album.order(date: :desc).limit(12).pluck(:artwork)
      end

    albums.map.with_index do |album, index|
      cover = MiniMagick::Image.open album
      name = "#{tmp}/#{index + 1}.jpg"
      cover.write name
      name
    end
  end

  def ribbon(names, result)
    names *= 2

    MiniMagick::Tool::Convert.new do |convert|
      convert.append

      names.each do |i|
        convert << i
      end

      convert << "#{tmp}/#{result}.jpg"
    end
  end

  def shifted_ribbon(names, result, percent, split = 'split')
    first = names.shift

    MiniMagick::Tool::Convert.new do |convert|
      convert.crop

      convert << "100%x#{percent}%"

      convert << first
      convert << "#{tmp}/#{split}.jpg"
    end

    if percent < 50
      MiniMagick::Tool::Convert.new do |convert|
        convert.append

        convert << "#{tmp}/#{split}-1.jpg"
        convert << "#{tmp}/#{split}-2.jpg"
        convert << "#{tmp}/#{split}-3.jpg"

        convert << "#{tmp}/#{split}-1.jpg"
      end
    end

    names.unshift "#{tmp}/#{split}-1.jpg"
    names.push "#{tmp}/#{split}-0.jpg"

    ribbon(names, result)
  end

  def gen_ribbon(names, result, percent = nil)
    if percent
      shifted_ribbon(names, result, percent)
    else
      ribbon(names, result)
    end
  end

  def combine_ribbons(result, left, right)
    MiniMagick::Tool::Convert.new do |convert|
      convert.append.+

      convert << "#{tmp}/#{left}.jpg"
      convert << "#{tmp}/#{right}.jpg"

      convert << "#{result}.jpg"
    end
  end

  def generate_wall
    names = prepare_images

    gen_ribbon(names[0..2], 'r1')
    gen_ribbon(names[3..5], 'r2', 66)
    combine_ribbons("#{tmp}/left", 'r1', 'r2')

    gen_ribbon(names[6..8], 'r4')
    gen_ribbon(names[9..11], 'r3', 33)
    combine_ribbons("#{tmp}/right", 'r3', 'r4')

    combine_ribbons("#{output}/wall", 'left', 'right')

    Rails.logger.info 'Successfully generated album wall'
  end
end
