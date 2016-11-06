namespace :albums do
  desc 'Generate album wall from latest album cover images'
  task wall: :verbose do
    puts 'Generating album wall...'
    awg = AlbumWallGenerator.new(false)
    awg.generate_wall
    puts 'Done'
  end

  desc 'Generate album wall from latest Best New Music album cover images'
  task 'wall:bnm' => :verbose do
    puts 'Generating BNM album wall...'
    awg = AlbumWallGenerator.new(true)
    awg.generate_wall
    puts 'Done'
  end
end
