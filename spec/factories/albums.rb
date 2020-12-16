FactoryBot.define do
  factory :album do
    title { Faker::Lorem.sentence(word_count: 10) }
    p4k_id { Faker::Number.number(digits: 5) }
    artist { [Faker::Name.name] }
    label { [Faker::Company.name] }
    genre { Faker::Lorem.words(number: 3) }
    year { Faker::Time.between(from: 10.years.ago, to: Time.now).year }
    date { Faker::Time.between(from: 10.years.ago, to: Time.now) }
    artwork { Faker::Avatar.image(slug: 'artwork', size: '300x300', format: 'jpg') }
    reviewer { Faker::Name.name }
    source { Faker::Internet.url }
    rating { rand(0.0...10.0).round(1) }
    reissue { false }
    bnm { false }

    factory :invalid_album do
      title { nil }
    end
  end
end
