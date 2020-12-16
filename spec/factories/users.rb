FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 3..32) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { :user }

    factory :admin do
      role { :admin }
    end
  end
end
