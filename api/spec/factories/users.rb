FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 12) }

    trait :confirmed do
      confirmed_at { Faker::Date.forward }
    end
  end
end
