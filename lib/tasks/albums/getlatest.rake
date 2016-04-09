namespace :albums do
  desc 'Get latest Pitchfork reviews and store them in DB'
  task getlatest: :verbose do
    puts 'Getting latest albums'
    parser = PitchforkParserService.new(ENV['RICHFORKDB'], 'albums')
    parser.update
    puts 'Done'
  end
end
