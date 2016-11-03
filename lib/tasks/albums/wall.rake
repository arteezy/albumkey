namespace :albums do
  desc 'Generate album wall from latest album cover images'
  task wall: :verbose do
    puts 'Generating album wall...'
    awg = AlbumWallGenerator.new
    awg.generate_wall
    puts 'Done'
  end
end
