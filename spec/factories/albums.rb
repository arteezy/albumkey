FactoryBot.define do
  factory :album do
    title { Faker::Lorem.sentence }
    p4k_id { Faker::Number.number(5) }
    artist { [Faker::Name.name] }
    label { [Faker::Company.name] }
    genre { Faker::Lorem.words(3) }
    year { Faker::Time.between(10.years.ago, Time.now).year }
    date { Faker::Time.between(10.years.ago, Time.now) }
    artwork { Faker::Avatar.image('artwork', '300x300', 'jpg') }
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
