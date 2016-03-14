require 'pitchfork_parser'

namespace :albums do
  desc 'Perform the fullscan of all Pitchfork album reviews'
  task fullscan: :verbose do
    puts 'Parsing Pitchfork...'
    parser = PitchforkParser.new(ENV['RICHFORKDB'], 'albums')
    parser.prepare_link_list
    parser.fullscan
    puts 'Done'
  end
end
