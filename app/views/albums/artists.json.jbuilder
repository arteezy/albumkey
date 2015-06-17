json.cache! ['v1', @artists], expires_in: 1.hour do
  json.array!(@artists)
end
