require 'pitchfork_parser'

desc "Perform the fullscan of all Pitchfork album reviews"
task fullscan: :environment do
  parser = PitchforkParser.new(ENV['RICHFORKDB'], 'albums')
  parser.fullscan
end
