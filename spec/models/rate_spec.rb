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

  it 'is invalid with a rate not in range' do
    rate = build(:invalid_rate)
    rate.valid?
    expect(rate.errors[:rate]).to include(a_string_matching /than or equal to/)
  end
end
