class List
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  belongs_to :user
  has_and_belongs_to_many :albums

  enum :category, [:personal, :community, :staff]

  field :title, type: String

  validates :title,    presence: true
  validates :category, presence: true
  validates :user,     presence: true
end
