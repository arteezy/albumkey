SitemapGenerator::Sitemap.default_host = 'http://albumkey.com'
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add stats_albums_path, priority: 0.5, changefreq: 'weekly'
  add search_albums_path, priority: 0.5, changefreq: 'weekly'
  add new_user_session_path, priority: 0.3, changefreq: 'monthly'
  add new_user_registration_path, priority: 0.3, changefreq: 'monthly'

  Album.each do |album|
    add album_path(album), priority: 0.8, changefreq: 'daily'
  end
end
