namespace :slugs do
  desc 'Update slugs if there are albums without them'
  task slugs_update: :environment do
    puts 'Updating slugs...'
    Album.where(slugs: nil).each(&:update)
    puts 'Done'
  end
end
