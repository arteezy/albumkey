FactoryGirl.define do
  factory :list do
    title { Faker::Lorem.sentence }
    category :personal
    association :user, factory: :user

    factory :invalid_list do
      title nil
    end
  end
end
