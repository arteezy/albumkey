SitemapGenerator::Sitemap.default_host = 'http://richfork.ml'

SitemapGenerator::Sitemap.create do
  add stats_path, priority: 0.5, changefreq: 'weekly'
  add search_path, priority: 0.5, changefreq: 'weekly'
  add new_user_session_path, priority: 0.3, changefreq: 'monthly'
  add new_user_registration_path, priority: 0.3, changefreq: 'monthly'

  Album.each do |album|
    add album_path(album), priority: 0.8, changefreq: 'daily'
  end
end
