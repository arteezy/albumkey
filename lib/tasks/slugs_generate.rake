desc 'Generate slugs for all existing albums in database'
task slugs_generate: :environment do
  puts 'Generating slugs...'
  Album.each(&:update)
  puts 'Done'
end
