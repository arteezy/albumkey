json.array!(@albums) do |album|
  json.extract! album, :id, :p4k_id, :artist, :title, :slug, :label, :year,
    :date, :genre, :reviewer, :rating, :artwork, :source, :reissue, :bnm
  json.url album_url(album, format: :json)
end
