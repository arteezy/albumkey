class List
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::SortedRelations
  include Mongoid::Slug
  include Mongoid::Enum

  belongs_to :user
  has_and_belongs_to_many :albums

  enum :category, [:personal, :community, :staff]

  field :title,     type: String
  field :positions, type: Array, default: []

  validates :title,    presence: true
  validates :category, presence: true
  validates :user,     presence: true

  slug :title

  def move_album(album, direction)
    return unless albums.include?(album)

    left = sorted_albums.index(album)
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

    index = positions[sorted_albums.index(album)]
    positions.delete(index)
    albums.delete(album)
    freeze_relation_ids

    positions.map! do |p|
      if p > index
        p - 1
      elsif p < index
        p
      end
    end
  end

  def ranked_albums
    positioned_albums = positions.zip(sorted_albums)
    positioned_albums.sort.transpose.last
  end

  def self.categories_for_select
    CATEGORY.map do |category|
      [
        category.to_s.titleize,
        category
      ]
    end
  end
end
