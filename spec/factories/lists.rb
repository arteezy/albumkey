FactoryGirl.define do
  factory :list do
    title { Faker::Lorem.sentence }
    category :personal
    positions [3, 1, 2]
    association :user, factory: :user

    factory :invalid_list do
      title nil
    end
  end
end
