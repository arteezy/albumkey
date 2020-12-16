FactoryBot.define do
  factory :comment do
    user_name { Faker::Internet.username(specifier: 3..32) }
    user_avatar { Faker::Avatar.image(slug: 'avatar', size: '33x33', format: 'jpg') }
    body { Faker::Lorem.sentence(word_count: 10) }
    association :user, factory: :user
    association :album, factory: :album

    factory :invalid_comment do
      body { nil }
    end
  end
end
