class Article
  include Mongoid::Document
  #field :id, type: String
  #field :_id, type: String, default: ->{ id }
  has_many :rates

  def self.search(search)
    if search
      where(artist: Regexp.new("#{search}", true)).distinct(:artist)
    else
      all.distinct(:artist)
    end
  end
end
