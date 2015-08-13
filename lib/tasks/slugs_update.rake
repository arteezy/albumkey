desc "Generate slugs if there are albums without them"
task slugs_update: :environment do
  Album.where(:slugs.exists => false).each { |album| album.update }
end
