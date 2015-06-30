require 'rails_helper'

describe Rate, type: :model do
  it 'has a valid factory' do
    expect(build(:rate)).to be_valid
  end

  it 'is invalid without a rate' do
    rate = build(:rate, rate: nil)
    rate.valid?
    expect(rate.errors[:rate]).to include("can't be blank")
  end
end
