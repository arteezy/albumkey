FactoryBot.define do
  factory :rate do
    rate { rand(0.0...10.0).round(1) }
    association :user, factory: :user
    association :album, factory: :album

    factory :invalid_rate do
      rate -13.3
    end
  end
end
