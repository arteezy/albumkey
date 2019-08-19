class List
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  extend Enumerize

  belongs_to :user
  has_and_belongs_to_many :albums

  field :category
  enumerize :category, in: [:personal, :community, :staff], default: :personal, predicates: true

  field :title,     type: String
  field :positions, type: Array,   default: []
  field :closed,    type: Boolean, default: false

  validates :title,    presence: true
  validates :category, presence: true
  validates :user,     presence: true

  slug :title

  scope :opened, -> { where(closed: false) }

  scope :personal, -> { where(category: :personal) }
  scope :community, -> { where(category: :community) }
  scope :staff, -> { where(category: :staff) }

  def move_album(album, direction)
    return unless albums.include?(album)

    left = albums.asc.to_a.index(album)
    index = positions[left]

    if direction == :up
      return unless index > 1
      right = positions.index(index - 1)
    elsif direction == :down
      return unless index < positions.size
      right = positions.index(index + 1)
    end

    positions[left], positions[right] = positions[right], positions[left]
  end

  def delete_album(album)
    return unless albums.include?(album)

    index = positions[albums.asc.to_a.index(album)]
    positions.delete(index)
    albums.delete(album)

    positions.map! do |p|
      if p > index
        p - 1
      elsif p < index
        p
      end
    end
  end

  def ranked_albums
    positioned_albums = positions.zip(albums.asc)
    positioned_albums.sort.transpose.last
  end

  def self.categories_for_select
    category.values.map do |category|
      [
        category.to_s.titleize,
        category
      ]
    end
  end
end
