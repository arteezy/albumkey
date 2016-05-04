namespace :albums do
  desc 'Perform the fullscan of all Pitchfork album reviews'
  task fullscan: :verbose do
    puts 'Parsing Pitchfork...'
    parser = PitchforkParserService.new(ENV['MONGODB_URL'], 'albums')
    parser.prepare_link_list
    parser.fullscan
    puts 'Done'
  end
end
