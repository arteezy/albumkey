require 'pitchfork_parser'

desc "Update album database with latest Pitchfork reviews"
task update: :environment do
  parser = PitchforkParser.new(ENV['RICHFORKDB'], 'albums')
  parser.update
end
