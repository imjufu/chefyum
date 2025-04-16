FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 12) }

    trait :confirmed do
      after(:create) do |user|
        user.confirm!
      end
    end
  end
end
