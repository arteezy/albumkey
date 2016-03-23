require 'rails_helper'

describe Album, type: :model do
  it 'has a valid factory' do
    expect(build(:album)).to be_valid
  end

  context 'validations' do
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

    it 'is invalid without a source URL' do
      album = build(:album, source: nil)
      album.valid?
      expect(album.errors[:source]).to include("can't be blank")
    end

    it 'is invalid without a rating' do
      album = build(:album, rating: nil)
      album.valid?
      expect(album.errors[:rating]).to include("can't be blank")
    end
  end

  context 'search' do
    let(:search_album1) { create(:album, title: 'Foo', artist: ['Bar'], label: ['Lorem']) }
    let(:search_album2) { create(:album, title: 'Boo', artist: ['Far'], label: ['Ipsum']) }

    it 'matches albums with valid query' do
      expect(subject.class.search('ar')).to match_array([search_album1, search_album2])
    end

    it 'doesnt match albums with invalid query' do
      expect(subject.class.search('Ipsum')).to match_array([search_album2])
    end
  end

  context 'slug' do
    it 'is generated' do
      expect(create(:album).slug).to_not be_nil
    end

    it 'is valid with single artist' do
      album = create(:album, artist: ['Bar'], title: 'Foo')
      expect(album.slug).to eq('bar-foo')
    end

    it 'is valid with array of artists' do
      album = create(:album, artist: ['Lorem', 'Ipsum'], title: 'Dolor')
      expect(album.slug).to eq('lorem-ipsum-dolor')
    end

    it 'is unique' do
      first = create(:album, artist: ['Bar'], title: 'Foo')
      second = create(:album, artist: ['Bar'], title: 'Foo')
      expect(first.slug).to_not eq(second.slug)
    end
  end
end
