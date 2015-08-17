namespace :albums do
  desc 'Update album database with latest Pitchfork reviews'
  task update: :environment do
    puts 'Updating latest albums'
    parser = PitchforkParser.new(ENV['RICHFORKDB'], 'albums')
    parser.update
    puts 'Done'
  end
end
