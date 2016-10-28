class AlbumWallGenerator
  def prepare_images
    albums = Album.order(date: :desc).limit(12).pluck(:artwork)

    names = []

    albums.each_with_index do |album, index|
      cover = MiniMagick::Image.open album
      name = "#{index + 1}.jpg"
      cover.write name
      names.push name
    end

    names
  end

  def ribbon(names, output)
    names *= 2

    MiniMagick::Tool::Convert.new do |convert|
      convert.append

      names.each do |i|
        convert << i
      end

      convert << "#{output}.jpg"
    end
  end

  def shifted_ribbon(names, output, percent, split = 'split')
    first = names.shift

    MiniMagick::Tool::Convert.new do |convert|
      convert.crop

      convert << "100%x#{percent}%"

      convert << first
      convert << "#{split}.jpg"
    end

    if percent < 50
      MiniMagick::Tool::Convert.new do |convert|
        convert.append

        convert << "#{split}-1.jpg"
        convert << "#{split}-2.jpg"
        convert << "#{split}-3.jpg"

        convert << "#{split}-1.jpg"
      end
    end

    names.unshift "#{split}-1.jpg"
    names.push "#{split}-0.jpg"

    ribbon(names, output)
  end

  def gen_ribbon(names, output, percent = nil)
    if percent
      shifted_ribbon(names, output, percent)
    else
      ribbon(names, output)
    end
  end

  def combine_ribbons(output, left, right)
    MiniMagick::Tool::Convert.new do |convert|
      convert.append.+

      convert << "#{left}.jpg"
      convert << "#{right}.jpg"

      convert << "#{output}.jpg"
    end
  end

  def generate_wall
    names = prepare_images

    gen_ribbon(names[0..2], 'r1')
    gen_ribbon(names[3..5], 'r2', 66)
    combine_ribbons('left', 'r1', 'r2')

    gen_ribbon(names[6..8], 'r4')
    gen_ribbon(names[9..11], 'r3', 33)
    combine_ribbons('right', 'r3', 'r4')

    combine_ribbons('wall', 'left', 'right')
  end
end
