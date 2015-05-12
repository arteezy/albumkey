require 'rails_helper'

describe Album, type: :model do
  it 'has a valid factory' do
    expect(build(:album)).to be_valid
  end

  it 'is invalid without a title' do
    album = build(:album, title: nil)
    album.valid?
    expect(album.errors[:title]).to include("can't be blank")
  end

  it 'is invalid without an artist' do
    album = build(:album, artist: nil)
    album.valid?
    expect(album.errors[:artist]).to include("can't be blank")
  end

  it 'is invalid without a label' do
    album = build(:album, label: nil)
    album.valid?
    expect(album.errors[:label]).to include("can't be blank")
  end

  it 'is invalid without a year' do
    album = build(:album, year: nil)
    album.valid?
    expect(album.errors[:year]).to include("can't be blank")
  end

  it 'is invalid without a date' do
    album = build(:album, date: nil)
    album.valid?
    expect(album.errors[:date]).to include("can't be blank")
  end

  it 'is invalid without an artwork' do
    album = build(:album, artwork: nil)
    album.valid?
    expect(album.errors[:artwork]).to include("can't be blank")
  end

  it 'is invalid without an URL' do
    album = build(:album, url: nil)
    album.valid?
    expect(album.errors[:url]).to include("can't be blank")
  end

  it 'is invalid without a score' do
    album = build(:album, score: nil)
    album.valid?
    expect(album.errors[:score]).to include("can't be blank")
  end

  context 'slug' do
    it 'is generated' do
      expect(create(:album).slug).to_not be_nil
    end

    it 'is valid' do
      album = create(:album, artist: 'Bar', title: 'Foo')
      expect(album.slug).to eq('bar-foo')
    end

    it 'is unique' do
      first = create(:album, artist: 'Bar', title: 'Foo')
      second = create(:album, artist: 'Bar', title: 'Foo')
      expect(first.slug).to_not eq(second.slug)
    end
  end
end
