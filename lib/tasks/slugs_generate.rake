desc "Generate slugs for all exisitng albums in database"
task slugs_generate: :environment do
  Album.each(&:update)
end
