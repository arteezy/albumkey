require 'rails_helper'

RSpec.describe List, type: :model do
  it 'has a valid factory' do
    expect(build(:list)).to be_valid
  end

  it 'sets proper categories for select' do
    cats_hash = List.categories_for_select.to_h
    expect(cats_hash.keys).to match_array(List.category.values.map { |c| c.to_s.titleize })
    expect(cats_hash.values).to match_array(List.category.values)
  end

  context 'positions' do
    let(:list) { create(:list) }
    let(:a1)   { build(:album, title: 'One') }
    let(:a2)   { build(:album, title: 'Two') }
    let(:a3)   { build(:album, title: 'Three') }

    before(:each) do
      list.albums << [a1, a2, a3]
      list.positions = [1, 2, 3]
    end

    it "doesn\'t add duplicate records" do
      list.albums << a3
      a3.lists << list

      expect(list.ranked_albums).to match_array [a1, a2, a3]
      expect(list.positions).to match_array [1, 2, 3]
    end

    it 'correctly moves album position up' do
      list.move_album(a3, :up)

      expect(list.ranked_albums).to match_array [a1, a3, a2]
      expect(list.positions).to match_array [1, 3, 2]
    end

    it 'correctly moves album position down' do
      list.move_album(a1, :down)

      expect(list.ranked_albums).to match_array [a2, a1, a3]
      expect(list.positions).to match_array [2, 1, 3]
    end

    it 'correctly deletes album' do
      list.delete_album(a2)

      expect(list.ranked_albums).to match_array [a1, a3]
      expect(list.positions).to match_array [1, 2]
    end
  end

  context 'validations' do
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

  context 'slug' do
    it 'is generated' do
      expect(create(:list).slug).to_not be_nil
    end

    it 'is in right format' do
      list = create(:list, title: 'Top 100 List')
      expect(list.slug).to eq('top-100-list')
    end

    it 'is updated on list update' do
      list = create(:list)
      old_slug = list.slug
      list.update(title: 'Updated List')
      expect(list.slug).to_not eq(old_slug)
      expect(list.slug).to eq('updated-list')
    end

    it 'is unique' do
      first = create(:list, title: 'My List')
      second = create(:list, title: 'My List')
      expect(first.slug).to_not eq(second.slug)
    end
  end
end
