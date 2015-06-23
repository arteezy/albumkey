json.cache! ['artists-json', @artists], expires_in: 1.hour do
  json.array!(@artists)
end
