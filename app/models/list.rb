class List
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  belongs_to :user
  has_and_belongs_to_many :albums

  enum :category, [:personal, :community, :staff]

  field :title,     type: String
  field :positions, type: Array, default: []

  validates :title,    presence: true
  validates :category, presence: true
  validates :user,     presence: true

  def ranked_albums
    positions.zip(albums).sort.transpose.last
  end

  def move_album(album, direction)
    return unless albums.include?(album)

    left = albums.index(album)
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

    index = positions[albums.index(album)]
    positions.delete(index)
    positions.map! do |p|
      if p > index
        p - 1
      elsif p < index
        p
      end
    end

    albums.delete(album)
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
