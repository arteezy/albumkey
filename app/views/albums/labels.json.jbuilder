json.cache! ['v1', @labels], expires_in: 1.hour do
  json.array!(@labels)
end
