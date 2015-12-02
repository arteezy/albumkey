class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :p4k_id, type: Integer
  field :artist, type: String
  field :label, type: String
  field :year, type: String
  field :date, type: Date
  field :artwork, type: String
  field :source, type: String
  field :rating, type: Float
  field :reissue, type: Boolean
  field :bnm, type: Boolean

  validates :title, presence: true
  validates :artist, presence: true
  validates :label, presence: true
  validates :year, presence: true
  validates :date, presence: true
  validates :artwork, presence: true
  validates :source, presence: true
  validates :rating, presence: true

  has_many :rates, dependent: :destroy
  embeds_many :comments

  index title: 1
  index artist: 1
  index label: 1
  index rating: 1
  index({ date: -1, created_at: 1 })
  index({ p4k_id: 1 }, unique: true, sparse: true)

  slug :artist, :title

  def self.search(query)
    if query
      any_of([
        { artist: Regexp.new("#{query}", true) },
        { title:  Regexp.new("#{query}", true) },
        { label:  Regexp.new("#{query}", true) }
      ])
    else
      all
    end
  end
end
