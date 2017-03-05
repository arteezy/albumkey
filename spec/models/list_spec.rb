require 'rails_helper'

RSpec.describe List, type: :model do
  it 'sets proper categories for select' do
    expect(List.categories_for_select.to_h.values).to eq(List::CATEGORY)
  end

  it 'has a valid factory' do
    expect(build(:list)).to be_valid
  end

  it 'is invalid without a title' do
    list = build(:list, title: nil)
    list.valid?
    expect(list.errors[:title]).to include("can't be blank")
  end

  it 'is invalid without a category' do
    list = build(:list, category: nil)
    list.valid?
    expect(list.errors[:category]).to include("can't be blank")
  end

  it 'is invalid without a user' do
    list = build(:list, user: nil)
    list.valid?
    expect(list.errors[:user]).to include("can't be blank")
  end
end
