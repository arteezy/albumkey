require 'rails_helper'

describe Rate, type: :model do
  it 'has a valid factory' do
    expect(build(:rate)).to be_valid
  end
end
