class Album
  include Mongoid::Document
  include Mongoid::Slug

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

  has_many :rates

  slug :artist, :title

  def self.search_by_artist(artist)
    if artist
      where(artist: Regexp.new("#{artist}", true))
    else
      all
    end
  end
end
