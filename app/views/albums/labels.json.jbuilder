json.cache! 'labels-json', expires_in: 1.hour do
  json.array! @labels
end
