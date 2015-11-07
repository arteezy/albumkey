require 'pitchfork_parser'

namespace :albums do
  desc 'Get latest Pitchfork reviews and store them in DB'
  task getlatest: :environment do
    puts 'Getting latest albums'
    parser = PitchforkParser.new(ENV['RICHFORKDB'], 'albums')
    parser.update
    puts 'Done'
  end
end
