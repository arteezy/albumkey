require 'pitchfork_parser'

desc "Get latest Pitchfork album reviews in remote DB"
task update_remote: :environment do
  parser = PitchforkParser.new(ENV['RICHFORKDB'], 'albums')
  parser.footprint
end
