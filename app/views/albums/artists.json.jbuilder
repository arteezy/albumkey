json.cache! 'artists-json', expires_in: 1.hour do
  json.array! @artists
end
