FactoryBot.define do
  factory :comment do
    user_name { Faker::Internet.user_name(3..32) }
    user_avatar { Faker::Avatar.image('avatar', '33x33', 'jpg') }
    body { Faker::Lorem.sentence }
    association :user, factory: :user
    association :album, factory: :album

    factory :invalid_comment do
      body nil
    end
  end
end
