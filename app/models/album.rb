class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :p4k_id, type: Integer
  field :artist, type: Array
  field :label, type: Array
  field :year, type: String
  field :date, type: Date
  field :artwork, type: String
  field :source, type: String
  field :genre, type: Array
  field :reviewer, type: String
  field :rating, type: Float
  field :reissue, type: Boolean
  field :bnm, type: Boolean

  validates :title, presence: true
  validates :p4k_id, presence: true, uniqueness: true
  validates :artist, presence: true
  validates :label, presence: true
  validates :year, presence: true
  validates :date, presence: true
  validates :artwork, presence: true
  validates :source, presence: true
  validates :reviewer, presence: true
  validates :rating, presence: true, numericality: true
  validates :reissue, presence: true
  validates :bnm, presence: true

  index(title: 1)
  index(artist: 1)
  index(label: 1)
  index(rating: 1)
  index(date: -1, created_at: 1)
  # An index that is both sparse and unique prevents collection
  # from having documents with duplicate values for a field
  # but allows multiple documents that omit the key.
  index({ p4k_id: 1 }, unique: true, sparse: true)

  has_many :rates, dependent: :destroy
  embeds_many :comments # implies dependent: :destroy

  slug :artist, :title

  scope :artist, -> (artist) { where(artist: artist) if artist.present? }
  scope :year, -> (year) { where(year: year) if year.present? }
  scope :genre, -> (genre) { where(genre: genre) if genre.present? }
  scope :label, -> (label) { where(label: label) if label.present? }
  scope :reissue, -> (reissue) { reissue == '0' ? where(reissue: false) : where(reissue: true) if reissue.present? }
  scope :bnm, -> (bnm) { bnm == '0' ? where(bnm: false) : where(bnm: true) if bnm.present? }
  scope :rating_range, -> (min, max) { gte(rating: min).lte(rating: max) }
  scope :albums_order, -> (order, dir) { order_by(order => dir, created_at: :asc) }

  def self.search(query)
    if query.present?
      re = Regexp.new(query, true)
      any_of([
        { artist: re },
        { title: re },
        { label: re }
      ])
    else
      all
    end
  end
end
