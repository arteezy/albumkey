class Rate
  include Mongoid::Document

  field :rate, type: Float

  belongs_to :user
  belongs_to :album

  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 10.0 }
  validates :user_id, presence: true
  validates :album_id, presence: true
end
