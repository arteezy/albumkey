require 'rails_helper'

describe Comment, type: :model do
  it 'has a valid factory' do
    expect(build(:comment)).to be_valid
  end

  it 'is invalid without a user email' do
    comment = build(:comment, user_name: nil)
    comment.valid?
    expect(comment.errors[:user_name]).to include("can't be blank")
  end

  it 'is invalid without an user avatar' do
    comment = build(:comment, user_avatar: nil)
    comment.valid?
    expect(comment.errors[:user_avatar]).to include("can't be blank")
  end

  it 'is invalid without a comment body' do
    comment = build(:comment, body: nil)
    comment.valid?
    expect(comment.errors[:body]).to include("can't be blank")
  end
end
