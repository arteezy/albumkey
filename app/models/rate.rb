class Rate
  include Mongoid::Document
  field :rate, type: Float

  belongs_to :user
  belongs_to :article
end
