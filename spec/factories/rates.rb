FactoryGirl.define do
  factory :rate do
    rate { rand(0.0...10.0).round(1) }
    association :user, factory: :user
    association :album, factory: :album
  end
end
