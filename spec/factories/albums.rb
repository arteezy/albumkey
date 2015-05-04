FactoryGirl.define do
  factory :album do
    title { Faker::Lorem.sentence }
    artist { Faker::Name.name }
    label { Faker::Company.name }
    year { Faker::Time.between(10.years.ago, Time.now).year }
    date { Faker::Time.between(10.years.ago, Time.now) }
    artwork { Faker::Avatar.image("album-artwork", "300x300", "jpg") }
    url { Faker::Internet.url }
    score { rand(0.0...10.0) }
    bnm false
    bnr false
  end
end
