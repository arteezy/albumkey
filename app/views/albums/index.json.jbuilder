json.array!(@albums) do |album|
  json.extract! album, :id, :title, :artist, :label, :year, :date, :artwork, :url, :score, :bnm, :bnr
  json.url album_url(album, format: :json)
end