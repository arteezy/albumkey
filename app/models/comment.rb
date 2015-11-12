class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_email, type: String
  field :body, type: String

  belongs_to :user
  embedded_in :album
end
