json.cache! ['labels-json', @labels], expires_in: 1.hour do
  json.array!(@labels)
end
