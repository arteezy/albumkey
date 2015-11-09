json.array!(@comments) do |comment|
  json.extract! comment, :id, :user_email, :body, :album_id, :user_id
  json.url comment_url(comment, format: :json)
end
