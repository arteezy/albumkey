namespace :slugs do
  desc 'Generate slugs for all existing albums in database'
  task generate: :environment do
    puts 'Generating slugs...'
    Album.each(&:set_slug!)
    puts 'Done'
  end
end
