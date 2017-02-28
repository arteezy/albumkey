class List
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  belongs_to :user
  has_and_belongs_to_many :albums

  enum :category, [:personal, :community, :staff]

  field :title,     type: String
  field :positions, type: Array

  validates :title,    presence: true
  validates :category, presence: true
  validates :user,     presence: true

  def ranked
    positions.zip(albums).sort.transpose.last
  end
end
