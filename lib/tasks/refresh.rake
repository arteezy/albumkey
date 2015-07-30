require 'pitchfork_parser'

desc "Get latest Pitchfork album reviews"
task refresh: :environment do
  parser = PitchforkParser.new('richfork', 'albums')
  puts parser.footprint
end
