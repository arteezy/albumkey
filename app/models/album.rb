class Album
  include Mongoid::Document
  include Mongoid::Slug

  field :title, type: String
  field :artist, type: String
  field :label, type: String
  field :year, type: String
  field :date, type: Date
  field :artwork, type: String
  field :source, type: String
  field :rating, type: Float
  field :reissue, type: Mongoid::Boolean
  field :bnm, type: Mongoid::Boolean

  slug :artist, :title

  has_many :rates, dependent: :destroy

  validates :title, presence: true
  validates :artist, presence: true
  validates :label, presence: true
  validates :year, presence: true
  validates :date, presence: true
  validates :artwork, presence: true
  validates :source, presence: true
  validates :rating, presence: true

  def self.search_by_artist(artist)
    if artist
      where(artist: Regexp.new("#{artist}", true))
    else
      all
    end
  end
end
