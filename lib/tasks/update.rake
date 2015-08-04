require 'pitchfork_parser'

desc "Get latest Pitchfork album reviews"
task update: :environment do
  parser = PitchforkParser.new('richfork', 'albums')
  parser.footprint
end
