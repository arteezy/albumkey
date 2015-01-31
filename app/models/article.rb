class Article
  include Mongoid::Document

  field :url, type: String
  field :artist, type: String
  field :title, type: String
  field :label, type: String
  field :year, type: String
  field :date, type: String
  field :score, type: Float
  field :artwork, type: String
  field :bnm, type: Mongoid::Boolean
  field :bnr, type: Mongoid::Boolean

  has_many :rates

  def self.search(search)
    if search
      where(artist: Regexp.new("#{search}", true)).distinct(:artist).sort
    else
      all.distinct(:artist).sort
    end
  end
end
