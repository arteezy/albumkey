class List
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  belongs_to :user
  has_many :albums

  enum :category, [:personal, :community, :staff]

  field :title, type: String
end
