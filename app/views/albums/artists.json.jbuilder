json.cache! ['v1', @artists], expires_in: 10.minutes do
  json.array!(@artists)
end
