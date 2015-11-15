FactoryGirl.define do
  factory :comment do
    user_email { Faker::Internet.email }
    user_avatar { Faker::Avatar.image('avatar', '33x33', 'jpg') }
    body { Faker::Lorem.sentence }
    association :user, factory: :user
    association :album, factory: :album
  end
end
