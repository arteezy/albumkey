class Album
  include Mongoid::Document

  field :title, type: String
  field :artist, type: String
  field :label, type: String
  field :year, type: String
  field :date, type: String
  field :artwork, type: String
  field :url, type: String
  field :score, type: Float
  field :bnm, type: Mongoid::Boolean
  field :bnr, type: Mongoid::Boolean
end
