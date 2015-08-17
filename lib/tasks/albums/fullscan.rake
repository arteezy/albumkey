namespace :albums do
  desc 'Perform the fullscan of all Pitchfork album reviews'
  task fullscan: :environment do
    puts 'Parsing Pitchfork...'
    parser = PitchforkParser.new(ENV['RICHFORKDB'], 'albums')
    parser.fullscan
    puts 'Done'
  end
end
