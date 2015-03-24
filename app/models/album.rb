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

  slug :artist, :title

  has_many :rates

  validates :title, presence: true
  validates :artist, presence: true
  validates :label, presence: true
  validates :year, presence: true
  validates :date, presence: true
  validates :artwork, presence: true
  validates :url, presence: true
  validates :score, presence: true

  def self.search_by_artist(artist)
    if artist
      where(artist: Regexp.new("#{artist}", true))
    else
      all
    end
  end
end
