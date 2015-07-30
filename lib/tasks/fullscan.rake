require 'pitchfork_parser'

desc "Perform the fullscan of all Pitchfork album reviews"
task fullscan: :environment do
  parser = PitchforkParser.new('richfork', 'albums')
  parser.fullscan
end
