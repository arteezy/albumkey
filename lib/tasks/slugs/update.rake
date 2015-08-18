namespace :slugs do
  desc 'Update slugs if there are albums without them'
  task update: :environment do
    puts 'Updating slugs...'
    Album.where(slugs: nil).each(&:update)
    puts 'Done'
  end
end
