FactoryGirl.define do
  factory :list do
    title 'MyString'
    category :personal
    association :user, factory: :user
  end
end
